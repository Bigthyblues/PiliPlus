import 'dart:async' show StreamSubscription;

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/search/article_search_type.dart';
import 'package:PiliPlus/models/common/search/search_type.dart';
import 'package:PiliPlus/models/common/search/user_search_type.dart';
import 'package:PiliPlus/models/common/search/video_search_type.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/search_result/controller.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class SearchPanelController<R extends SearchNumData<T>, T>
    extends CommonListController<R, T> {
  SearchPanelController({
    required this.keyword,
    required this.searchType,
    required this.tag,
  });
  final String tag;
  final String keyword;
  final SearchType searchType;

  // sort
  // common
  String order = '';

  // video
  VideoDurationType? videoDurationType; // int duration
  VideoZoneType? videoZoneType; // int? tids;
  int? pubBegin;
  int? pubEnd;

  // user
  Rx<UserOrderType>? userOrderType;
  Rx<UserType>? userType;

  // article
  Rx<ArticleZoneType>? articleZoneType; // int? categoryId;

  SearchResultController? searchResultController;

  void onSortSearch({
    bool getBack = true,
    String? label,
  }) {
    if (getBack) Get.back();
    SmartDialog.dismiss();
    if (label != null) {
      SmartDialog.showToast("「$label」的筛选结果");
    }
    SmartDialog.showLoading(msg: 'loading');
    onReload().whenComplete(SmartDialog.dismiss);
  }

  StreamSubscription? _listener;

  void cancelListener() {
    _listener?.cancel();
  }

  @override
  void onInit() {
    super.onInit();
    try {
      searchResultController = Get.find<SearchResultController>(tag: tag);
      _listener = searchResultController!.toTopIndex.listen((index) {
        if (index == searchType.index) {
          scrollController.animToTop();
        }
      });
    } catch (_) {}
    queryData();
  }

  @override
  List<T>? getDataList(R response) {
    return response.list;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<R> response) {
    if (isRefresh) {
      searchResultController?.count[searchType.index] =
          response.response.numResults ?? 0;
    }
    return false;
  }

  bool _isCheeseSearchVideo(SearchVideoItemModel item) {
    // 搜索页课堂条目常见为 type=ketang，也可能带 cheese 标识或 /cheese/ 链接。
    final type = item.type?.toLowerCase();
    if (type == 'ketang' || type == 'cheese') {
      return true;
    }
    final arcurl = item.arcurl?.toLowerCase();
    if (arcurl != null && arcurl.contains('/cheese/')) {
      return true;
    }
    final tag = item.tag?.toLowerCase();
    return tag == 'cheese' || tag == '课堂';
  }

  bool _isBlacklistedCheese(SearchVideoItemModel item) {
    final mid = item.owner.mid;
    return mid != null && GlobalData().blackMids.contains(mid);
  }

  bool _shouldRemoveSearchItem(Object? item) {
    if (item is SearchVideoItemModel && _isCheeseSearchVideo(item)) {
      if (_isBlacklistedCheese(item)) {
        return true;
      }
      return Pref.hideCheeseSearchResults;
    }
    return false;
  }

  @override
  void handleListResponse(List<T> dataList) {
    dataList.removeWhere((item) {
      if (_shouldRemoveSearchItem(item)) {
        return true;
      }
      if (item is List) {
        item.removeWhere(_shouldRemoveSearchItem);
        return item.isEmpty;
      }
      return false;
    });
  }

  String? gaiaVtoken;

  @override
  Future<LoadingState<R>> customGetData() => SearchHttp.searchByType<R>(
    searchType: searchType,
    keyword: keyword,
    page: page,
    order: order,
    duration: videoDurationType?.index,
    tids: videoZoneType?.tids,
    orderSort: userOrderType?.value.orderSort,
    userType: userType?.value.index,
    categoryId: articleZoneType?.value.categoryId,
    pubBegin: pubBegin,
    pubEnd: pubEnd,
    gaiaVtoken: gaiaVtoken,
    onSuccess: (String gaiaVtoken) {
      this.gaiaVtoken = gaiaVtoken;
      queryData(page == 1);
    },
  );

  @override
  Future<void> onReload() {
    scrollController.jumpToTop();
    return super.onReload();
  }
}
