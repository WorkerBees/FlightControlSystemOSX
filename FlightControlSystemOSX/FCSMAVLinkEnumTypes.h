//
//  FCSMAVLinkEnumTypes.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/26/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "mavlink.h"

/**
 *  Flight mode -- what is controlling things?  These are defined by ArudPlane not by MAVlink.
 */
typedef NS_ENUM(uint32_t, FCSCustomFlightMode)
{
    /**
     *  Manual mode
     */
    FCSCustomFlightMode_MANUAL        = 0,
    /**
     *  Circle in place mode
     */
    FCSCustomFlightMode_CIRCLE        = 1,
    /**
     *  Stabilize
     */
    FCSCustomFlightMode_STABILIZE     = 2,
    /**
     *  Training mode
     */
    FCSCustomFlightMode_TRAINING      = 3,
    /**
     *  Acrobatic mode
     */
    FCSCustomFlightMode_ACRO          = 4,
    /**
     *  Fly-by-wire version A
     */
    FCSCustomFlightMode_FLY_BY_WIRE_A = 5,
    /**
     *  Fly-by-wire version B
     */
    FCSCustomFlightMode_FLY_BY_WIRE_B = 6,
    /**
     *  Cruise
     */
    FCSCustomFlightMode_CRUISE        = 7,
    /**
     *  Autotune mode
     */
    FCSCustomFlightMode_AUTOTUNE      = 8,
    /**
     *  UNUSED
     */
    FCSCustomFlightMode_RESERVED_9    = 9,
    /**
     *  Full autopilot
     */
    FCSCustomFlightMode_AUTO          = 10,
    /**
     *  Return to launch
     */
    FCSCustomFlightMode_RTL           = 11,
    /**
     *  Loiter
     */
    FCSCustomFlightMode_LOITER        = 12,
    /**
     *  UNUSED
     */
    FCSCustomFlightMode_RESERVED_13   = 13,
    /**
     *  UNUSED
     */
    // RESERVED FOR FUTURE USE
    FCSCustomFlightMode_RESERVED_14   = 14,
    /**
     *  Guided
     */
    // RESERVED FOR FUTURE USE
    FCSCustomFlightMode_GUIDED        = 15,
    /**
     *  Initializing
     */
    FCSCustomFlightMode_INITIALIZING  = 16
};

/**
 *  Type of UAV
 */
typedef NS_ENUM(uint8_t, FCSMAVType)
{
    /**
     *  Generic
     */
    FCSMAVType_GENERIC = MAV_TYPE_GENERIC,
    /**
     *  Fixed wing (ie plane)
     */
    FCSMAVType_FIXED_WING = MAV_TYPE_FIXED_WING,
    /**
     *  4-prop copter
     */
    FCSMAVType_QUADROTOR = MAV_TYPE_QUADROTOR,
    /**
     *  Coaxial copter
     */
    FCSMAVType_COAXIAL = MAV_TYPE_COAXIAL,
    /**
     *  Single prop copter
     */
    FCSMAVType_HELICOPTER = MAV_TYPE_HELICOPTER,
    /**
     *  Ground station antenna tracker
     */
    FCSMAVType_ANTENNA_TRACKER = MAV_TYPE_ANTENNA_TRACKER,
    /**
     *  Ground control station
     */
    FCSMAVType_GCS = MAV_TYPE_GCS,
    /**
     *  Airship
     */
    FCSMAVType_AIRSHIP = MAV_TYPE_AIRSHIP,
    /**
     *  Balloon
     */
    FCSMAVType_FREE_BALLOON = MAV_TYPE_FREE_BALLOON,
    /**
     *  Rocket
     */
    FCSMAVType_ROCKET = MAV_TYPE_ROCKET,
    /**
     *  Ground rover
     */
    FCSMAVType_GROUND_ROVER = MAV_TYPE_GROUND_ROVER,
    /**
     *  Surface boat
     */
    FCSMAVType_SURFACE_BOAT = MAV_TYPE_SURFACE_BOAT,
    /**
     *  Submarine
     */
    FCSMAVType_SUBMARINE = MAV_TYPE_SUBMARINE,
    /**
     *  6-prop copter
     */
    FCSMAVType_HEXAROTOR = MAV_TYPE_HEXAROTOR,
    /**
     *  8-prop copter
     */
    FCSMAVType_OCTOROTOR = MAV_TYPE_OCTOROTOR,
    /**
     *  3-prop copter
     */
    FCSMAVType_TRICOPTER = MAV_TYPE_TRICOPTER,
    /**
     *  Flapping-wing birdlike thing
     */
    FCSMAVType_FLAPPING_WING = MAV_TYPE_FLAPPING_WING,
    /**
     *  Kite
     */
    FCSMAVType_KITE = MAV_TYPE_KITE,
};

/**
 *  Autopilot main controller type
 */
typedef NS_ENUM(uint8_t, FCSAutopilotType)
{
    /**
     *  Generic/Unknown
     */
    FCSAutoPilotType_GENERIC = MAV_AUTOPILOT_GENERIC,
    /**
     *  Pixhawk
     */
    FCSAutoPilotType_PIXHAWK = MAV_AUTOPILOT_PIXHAWK,
    /**
     *  Slugs
     */
    FCSAutoPilotType_SLUGS = MAV_AUTOPILOT_SLUGS,
    /**
     *  ArduPilotMega
     */
    FCSAutoPilotType_ARDUPILOTMEGA = MAV_AUTOPILOT_ARDUPILOTMEGA,
    /**
     *  OpenPilot
     */
    FCSAutoPilotType_OPENPILOT = MAV_AUTOPILOT_OPENPILOT,
    /**
     *  Generic - Waypoints only
     */
    FCSAutoPilotType_GENERIC_WAYPOINTS_ONLY = MAV_AUTOPILOT_GENERIC_WAYPOINTS_ONLY,
    /**
     *  Generic - Waypoints and simple nav only
     */
    FCSAutoPilotType_GENERIC_WAYPOINTS_AND_SIMPLE_NAVIGATION_ONLY = MAV_AUTOPILOT_GENERIC_WAYPOINTS_AND_SIMPLE_NAVIGATION_ONLY,
    /**
     *  Generic - Full mission capabilities
     */
    FCSAutoPilotType_GENERIC_MISSION_FULL = MAV_AUTOPILOT_GENERIC_MISSION_FULL,
    /**
     *  Invalid
     */
    FCSAutoPilotType_INVALID = MAV_AUTOPILOT_INVALID,
    /**
     *  PPZ
     */
    FCSAutoPilotType_PPZ = MAV_AUTOPILOT_PPZ,
    /**
     *  UDB
     */
    FCSAutoPilotType_UDB = MAV_AUTOPILOT_UDB,
    /**
     *  FP
     */
    FCSAutoPilotType_FP = MAV_AUTOPILOT_FP,
    /**
     *  Pixhawk 4
     */
    FCSAutoPilotType_PX4 = MAV_AUTOPILOT_PX4,
};

/**
 *  Base mode
 */
typedef NS_OPTIONS(uint8_t, FCSBaseModeFlags)
{
    /**
     *  Custom mode -- see custom mode field for specifics
     */
    FCSBaseModeFlag_CUSTOM_MODE_ENABLED = MAV_MODE_FLAG_CUSTOM_MODE_ENABLED,
    /**
     *  Testing enabled
     */
    FCSBaseModeFlag_TEST_ENABLED = MAV_MODE_FLAG_TEST_ENABLED,
    /**
     *  Autopilot enabled
     */
    FCSBaseModeFlag_AUTO_ENABLED = MAV_MODE_FLAG_AUTO_ENABLED,
    /**
     *  Guided mode enabled
     */
    FCSBaseModeFlag_GUIDED_ENABLED = MAV_MODE_FLAG_GUIDED_ENABLED,
    /**
     *  Stabilize mode enabled
     */
    FCSBaseModeFlag_STABILIZE_ENABLED = MAV_MODE_FLAG_STABILIZE_ENABLED,
    /**
     *  Hardware-in-the-loop enabled
     */
    FCSBaseModeFlag_HIL_ENABLED = MAV_MODE_FLAG_HIL_ENABLED,
    /**
     *  Manual control enabled
     */
    FCSBaseModeFlag_MANUAL_INPUT_ENABLED = MAV_MODE_FLAG_MANUAL_INPUT_ENABLED,
    /**
     *  Safety armed (ie SAFE)
     */
    FCSBaseModeFlag_SAFETY_ARMED = MAV_MODE_FLAG_SAFETY_ARMED,
};

/**
 *  State of the MAV
 */
typedef NS_ENUM(uint8_t, FCSMAVStateType)
{
    /**
     *  Unintialized
     */
    FCSMAVState_UNINIT = MAV_STATE_UNINIT,
    /**
     *  Booting
     */
    FCSMAVState_BOOT = MAV_STATE_BOOT,
    /**
     *  Calibrating
     */
    FCSMAVState_CALIBRATING = MAV_STATE_CALIBRATING,
    /**
     *  Standby
     */
    FCSMAVState_STANDBY = MAV_STATE_STANDBY,
    /**
     *  Active
     */
    FCSMAVState_ACTIVE = MAV_STATE_ACTIVE,
    /**
     *  Critical condition
     */
    FCSMAVState_CRITICAL = MAV_STATE_CRITICAL,
    /**
     *  Emergency condition
     */
    FCSMAVState_EMERGENCY = MAV_STATE_EMERGENCY,
    /**
     *  Power is off
     */
    FCSMAVState_POWEROFF = MAV_STATE_POWEROFF,
};

/**
 *  Coordinate system in use
 */
typedef NS_ENUM(uint8_t, FCSMAVFrameType)
{
    /**
     *  Global GPS coordinates, in WG84
     */
    FCSMavFrame_GLOBAL = MAV_FRAME_GLOBAL,
    /**
     *  Local relative frame where x,y,z represent offsets in meters North, East, Down
     */
    FCSMavFrame_LOCAL_NED = MAV_FRAME_LOCAL_NED,
    /**
     *  Not a real frame; essentially depends on the MAV_CMD for this item, but means that z should not be treated as altitiude, but should be treated as param7
     */
    FCSMavFrame_MISSION = MAV_FRAME_MISSION,
    /**
     *  Global GPS coordinates for lat,long and altitude is relative to "HOME", ie to waypoint 0.
     */
    FCSMavFrame_GLOBAL_RELATIVE_ALT = MAV_FRAME_GLOBAL_RELATIVE_ALT,
    /**
     *  Local relative frame where x,y,z represent offsets in meters East, North, Up
     */
    FCSMavFrame_LOCAL_ENU = MAV_FRAME_LOCAL_ENU,
};

/**
 *  Type of mission command
 */
typedef NS_ENUM(uint16_t, FCSMAVCMDType)
{
    /**
     *  A waypoint at x,y,z in the specified frame.
     */
    FCSMAVCMDType_NAV_WAYPOINT = MAV_CMD_NAV_WAYPOINT,
    /**
     *  Begin loitering forever around x,y,z in the specified frame
     */
    FCSMAVCMDType_NAV_LOITER_UNLIM = MAV_CMD_NAV_LOITER_UNLIM,
    /**
     *  Begin loitering for param1 turns around x,y,z in the specified frame
     */
    FCSMAVCMDType_NAV_LOITER_TURNS = MAV_CMD_NAV_LOITER_TURNS,
    /**
     *  Begin loitering for param1 deciseconds around x,y,z in the specified frame
     */
    FCSMAVCMDType_NAV_LOITER_TIME = MAV_CMD_NAV_LOITER_TIME,
    /**
     *  Return to launch; params ignored?
     */
    FCSMAVCMDType_NAV_RETURN_TO_LAUNCH = MAV_CMD_NAV_RETURN_TO_LAUNCH,
    /**
     *  Begin landing sequence at x,y,z in the specified frame.  This will essentially cut throttle and glide in from this point while holding plane level, and tipping nose up just before altitude = 0
     */
    FCSMAVCMDType_NAV_LAND = MAV_CMD_NAV_LAND,
    /**
     *  Fly to x,y,z in specified frame with minimum pitch of param1 degrees up; without airspeed sensor us param1 as target pitch.
     *  TODO: lat/lon ignored?
     */
    FCSMAVCMDType_NAV_TAKEOFF = MAV_CMD_NAV_TAKEOFF,
    /**
     *  TODO: Unknown
     */
    FCSMAVCMDType_NAV_ROI = MAV_CMD_NAV_ROI,
    /**
     *  TODO: Unknown
     */
    FCSMAVCMDType_NAV_PATHPLANNING = MAV_CMD_NAV_PATHPLANNING,
    /**
     *  Marker for top of NAV type commands
     *  When a waypoint is reached, any unexecuted commands above this command number are dropped, and the mission will move to the next command that is lower than this number.
     *  In other words, if you have a CMD_NAV_WAYPOINT followed by some CMD_CONDITION commands, and those conditions have not yet been met when the waypoint is reached,
     *  they will be dropped, and the mission will move on to the next CMD_NAV_* item.
     */
    FCSMAVCMDType_NAV_LAST = MAV_CMD_NAV_LAST,
    /**
     *  Delay for param3 seconds before continuing the mission
     */
    FCSMAVCMDType_CONDITION_DELAY = MAV_CMD_CONDITION_DELAY,
    /**
     *  Change altitude to final altitude of param2 in the specified frame, with change rate target of param3 cm/s; param3 must be at least 10 due to integer math.
     */
    FCSMAVCMDType_CONDITION_CHANGE_ALT = MAV_CMD_CONDITION_CHANGE_ALT,
    /**
     *  Wait until plane has covered distance of param3 meters before continuing the mission
     */
    FCSMAVCMDType_CONDITION_DISTANCE = MAV_CMD_CONDITION_DISTANCE,
    /**
     *  Change yaw angle of the plane to be param1 degrees, with speed of param2, direction (-1,1) in param3, rel(1)/abs(0) in param4
     *  TODO: no idea what this actually is; seems like maybe a copter thing?
     */
    FCSMAVCMDType_CONDITION_YAW = MAV_CMD_CONDITION_YAW,
    /**
     *  Marker for top of CONDITION type commands
     */
    FCSMAVCMDType_CONDITION_LAST = MAV_CMD_CONDITION_LAST,
    /**
     *  Change the current flight mode to param1
     */
    FCSMAVCMDType_DO_SET_MODE = MAV_CMD_DO_SET_MODE,
    /**
     *  Jump to mission item param1 and repeat param3 times.  param3 must be >=1 for this to ever execute.  Use param3=1 for a single jump.
     */
    FCSMAVCMDType_DO_JUMP = MAV_CMD_DO_JUMP,
    /**
     *  Change speed.  param1=(0=airspeed,1=ground speed), param2=speed in m/s (-1 means no change), param3= throttle percent (-1 means no change)
     */
    FCSMAVCMDType_DO_CHANGE_SPEED = MAV_CMD_DO_CHANGE_SPEED,
    /**
     *  Set "Home" location.  param1=(1=Use current, 0=Use specified), param2=alt, param3=lat, param4=lon
     *  @warning Note that alt,lat,lon are in param2,param3,param4 and NOT in x,y,z
     */
    FCSMAVCMDType_DO_SET_HOME = MAV_CMD_DO_SET_HOME,
    /**
     *  Set parameter param1 to value param2 (Not currently implemented in APM)
     */
    FCSMAVCMDType_DO_SET_PARAMETER = MAV_CMD_DO_SET_PARAMETER,
    /**
     *  Set relay number param1 to param2(0=off, 1=on)
     */
    FCSMAVCMDType_DO_SET_RELAY = MAV_CMD_DO_SET_RELAY,
    /**
     *  Cycle relay number param1, param2 times, every param3 seconds.  param3 <= 60.
     *  @warning A repeat relay or repeat servo command will cancel any current repeating event
     */
    FCSMAVCMDType_DO_REPEAT_RELAY = MAV_CMD_DO_REPEAT_RELAY,
    /**
     *  Set servo number param1(5-8) to param2(0=off, 1=on)
     */
    FCSMAVCMDType_DO_SET_SERVO = MAV_CMD_DO_SET_SERVO,
    /**
     *  Cycle servo number param1(5-8), param2 tims, every param3 seconds.  param3 <= 60.
     *  @warning A repeat relay or repeat servo command will cancel any current repeating event
     */
    FCSMAVCMDType_DO_REPEAT_SERVO = MAV_CMD_DO_REPEAT_SERVO,
    /**
     *  TODO: Unknown
     */
    FCSMAVCMDType_DO_CONTROL_VIDEO = MAV_CMD_DO_CONTROL_VIDEO,
    /**
     *  TODO: Marker for top of "DO" commands
     */
    FCSMAVCMDType_DO_LAST = MAV_CMD_DO_LAST,
    /**
     *  Begin preflight calibration mode
     */
    FCSMAVCMDType_PREFLIGHT_CALIBRATION = MAV_CMD_PREFLIGHT_CALIBRATION,
    /**
     *  Set preflight sensor offsets
     */
    FCSMAVCMDType_PREFLIGHT_SET_SENSOR_OFFSETS = MAV_CMD_PREFLIGHT_SET_SENSOR_OFFSETS,
    /**
     *  Set preflight storage
     */
    FCSMAVCMDType_PREFLIGHT_STORAGE = MAV_CMD_PREFLIGHT_STORAGE,
    /**
     *  Reboot/shutdown
     */
    FCSMAVCMDType_PREFLIGHT_REBOOT_SHUTDOWN = MAV_CMD_PREFLIGHT_REBOOT_SHUTDOWN,
    /**
     *  TODO: Unknown
     */
    FCSMAVCMDType_OVERRIDE_GOTO = MAV_CMD_OVERRIDE_GOTO,
    /**
     *  TODO: Unknown
     */
    FCSMAVCMDType_MISSION_START = MAV_CMD_MISSION_START,
    /**
     *  TODO: Unknown
     */
    FCSMAVCMDType_COMPONENT_ARM_DISARM = MAV_CMD_COMPONENT_ARM_DISARM,
};

/**
 *  Mission item ack/error types
 */
typedef NS_ENUM(uint8_t, FCSMavMissionAckType)
{
    /**
     *  OK
     */
    FCSMAVMissionAck_ACCEPTED = MAV_MISSION_ACCEPTED,
    /**
     *  Generic error
     */
    FCSMAVMissionAck_ERROR = MAV_MISSION_ERROR,
    /**
     *  Error: unsupported frame type
     */
    FCSMAVMissionAck_UNSUPPORTED_FRAME = MAV_MISSION_UNSUPPORTED_FRAME,
    /**
     *  Error: unsupported mission command
     */
    FCSMAVMissionAck_UNSUPPORTED = MAV_MISSION_UNSUPPORTED,
    /**
     *  Error: no space for the mission (too many items)
     */
    FCSMAVMissionAck_NO_SPACE = MAV_MISSION_NO_SPACE,
    /**
     *  Error: invalid mission
     */
    FCSMAVMissionAck_INVALID = MAV_MISSION_INVALID,
    /**
     *  Error: Invalid param1
     */
    FCSMAVMissionAck_INVALID_PARAM1 = MAV_MISSION_INVALID_PARAM1,
    /**
     *  Error: Invalid param2
     */
    FCSMAVMissionAck_INVALID_PARAM2 = MAV_MISSION_INVALID_PARAM2,
    /**
     *  Error: Invalid param3
     */
    FCSMAVMissionAck_INVALID_PARAM3 = MAV_MISSION_INVALID_PARAM3,
    /**
     *  Error: Invalid param4
     */
    FCSMAVMissionAck_INVALID_PARAM4 = MAV_MISSION_INVALID_PARAM4,
    /**
     *  Error: Invalid param5/X
     */
    FCSMAVMissionAck_INVALID_PARAM5_X = MAV_MISSION_INVALID_PARAM5_X,
    /**
     *  Error: Invalid param6/Y
     */
    FCSMAVMissionAck_INVALID_PARAM6_Y = MAV_MISSION_INVALID_PARAM6_Y,
    /**
     *  Error: Invalid param7/Z
     */
    FCSMAVMissionAck_INVALID_PARAM7 = MAV_MISSION_INVALID_PARAM7,
    /**
     *  Error: Invalid sequence number
     */
    FCSMAVMissionAck_INVALID_SEQUENCE = MAV_MISSION_INVALID_SEQUENCE,
    /**
     *  Error: Mission denied
     */
    FCSMAVMissionAck_DENIED = MAV_MISSION_DENIED,
};
