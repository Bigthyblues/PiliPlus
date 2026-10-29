# Recovered dependency snapshots

The original Git forks or their locked history are no longer publicly accessible. These local packages
preserve the exact production files and licenses from the commits previously
recorded in `pubspec.lock`:

| Package | Version | Original commit | Recovery source |
| --- | --- | --- | --- |
| file_picker | 10.3.10 | fd8afd89260436b63b9d41e150b4eb3c806cc8fd | https://github.com/vicajilau/flutter_file_picker/commit/fd8afd89260436b63b9d41e150b4eb3c806cc8fd |
| floating | 3.0.0 | a66ec0b9dabde6b5880a3f4f3425e57842a38e51 | https://github.com/wrbl606/floating/commit/a66ec0b9dabde6b5880a3f4f3425e57842a38e51 |
| chat_bottom_container | 0.3.2 | dba2bf10db4a6f89564d9be63ce17b18f0f7e3e5 | https://github.com/bggRGjQaUbCoE/flutter_chat_packages/commit/dba2bf10db4a6f89564d9be63ce17b18f0f7e3e5 |

The source files are unchanged, including the forks' iOS file picker and Android
picture-in-picture fixes, and the chat panel's `uiScale`, `keepChatPanel` and
`restoreChatPanel` APIs. Examples, package tests and development-only assets
are omitted. The app uses path dependencies so fresh builds do not depend on
upstream refs retaining these recovered commits.

To update either package, review the upstream changes against this snapshot,
preserve the required fork fixes, and update this provenance record.
