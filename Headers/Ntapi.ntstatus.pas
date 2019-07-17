unit Ntapi.ntstatus;

{$MINENUMSIZE 4}

interface

const
  NT_FACILITY_SHIFT = 16;
  NT_FACILITY_MASK = $FFF;

  FACILITY_NTWIN32 = $7;

  ERROR_SEVERITY_SUCCESS = $00000000;
  ERROR_SEVERITY_INFORMATIONAL = $40000000;
  ERROR_SEVERITY_WARNING = $80000000;
  ERROR_SEVERITY_ERROR = $C0000000;

  // Success
  STATUS_SUCCESS = $00000000;
  STATUS_ABANDONED = $00000080;
  STATUS_TIMEOUT = $00000102;
  STATUS_MORE_ENTRIES = $00000105;
  STATUS_NOT_ALL_ASSIGNED = $00000106;
  STATUS_SOME_NOT_MAPPED = $00000107;

  // Information
  STATUS_OBJECT_NAME_EXISTS = $40000000;

  // Warning
  STATUS_DATATYPE_MISALIGNMENT = $80000002;
  STATUS_BREAKPOINT = $80000003;
  STATUS_SINGLE_STEP = $80000004;
  STATUS_BUFFER_OVERFLOW = $80000005;
  STATUS_NO_MORE_ENTRIES = $8000001A;

  // Error
  STATUS_UNSUCCESSFUL = $C0000001;
  STATUS_NOT_IMPLEMENTED = $C0000002;
  STATUS_INVALID_INFO_CLASS = $C0000003;
  STATUS_INFO_LENGTH_MISMATCH = $C0000004;
  STATUS_INVALID_HANDLE = $C0000008;
  STATUS_INVALID_CID = $C000000B;
  STATUS_INVALID_PARAMETER = $C000000D;
  STATUS_ACCESS_DENIED = $C0000022;
  STATUS_BUFFER_TOO_SMALL = $C0000023;
  STATUS_OBJECT_TYPE_MISMATCH = $C0000024;
  STATUS_OBJECT_NAME_INVALID = $C0000033;
  STATUS_OBJECT_NAME_NOT_FOUND = $C0000034;
  STATUS_OBJECT_NAME_COLLISION = $C0000035;
  STATUS_THREAD_IS_TERMINATING = $C000004B;
  STATUS_INVALID_OWNER = $C000005A;
  STATUS_INVALID_PRIMARY_GROUP = $C000005B;
  STATUS_NO_IMPERSONATION_TOKEN = $C000005C;
  STATUS_CANT_DISABLE_MANDATORY = $C000005D;
  STATUS_NO_SUCH_LOGON_SESSION = $C000005F;
  STATUS_NO_SUCH_PRIVILEGE = $C0000060;
  STATUS_PRIVILEGE_NOT_HELD = $C0000061;
  STATUS_NONE_MAPPED = $C0000073;
  STATUS_INVALID_ACL = $C0000077;
  STATUS_INVALID_SID = $C0000078;
  STATUS_INVALID_SECURITY_DESCR = $C0000079;
  STATUS_NO_TOKEN = $C000007C;
  STATUS_BAD_IMPERSONATION_LEVEL = $C00000A5;
  STATUS_BAD_TOKEN_TYPE = $C00000A8;
  STATUS_NOT_SUPPORTED = $C00000BB;
  STATUS_VARIABLE_NOT_FOUND = $C0000100;
  STATUS_NOT_SAME_OBJECT = $C00001AC;
  STATUS_NOT_FOUND = $C0000225;
  STATUS_CANT_ENABLE_DENY_ONLY = $C00002B3;
  STATUS_ASSERTION_FAILURE = $C0000420;
  STATUS_NOT_CAPABLE = $C0000429;
  STATUS_IMPLEMENTATION_LIMIT = $C000042B;
  STATUS_WOW_ASSERTION = $C0009898;

implementation

end.
