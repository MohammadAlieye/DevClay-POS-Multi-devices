/// Compatibility re-exports — prefer `package:.../core/lan_api/...`.
library;

import '../lan_api/dtos/lan_dtos.dart';

export '../lan_api/lan_mode_service.dart';
export '../lan_api/client/lan_api_client.dart';
export '../lan_api/host/shop_host_server.dart';
export '../lan_api/dtos/lan_dtos.dart';
export '../lan_api/lan_api_paths.dart';
export '../lan_api/lan_api_errors.dart';

// Legacy names used by older call sites.
typedef LanHealthResponse = LanHealthDto;
typedef LanCreateSaleRequest = LanCreateSaleDto;
