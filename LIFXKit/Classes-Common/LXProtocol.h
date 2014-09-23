#import "Structle.h"
#import "LXProtocolTypes.h"
#import "LXProtocolMessages.h"
#include <stdint.h>


#define LX_PROTOCOL_V1        1024


/*

Level 0 - Frame.

+------+------------+--------+----+---------+
| size | descriptor | source | id | payload |
+------+------------+--------+----+---------+

uint16_t size:
  Size of frame in bytes little endian. 65,535 bytes max.

uint16_t:
   0..11 - protocol: 12 bit unsigned integer. 4095 max.

      12 - addressable: Frame includes address.
       0 - Is lx_frame_t
       1 - Is lx_frame_address_t

      13 - tagged: Frame targets tag or device in lx_frame_address_t.target.
       0 - Targets a device.
       1 - Targets tags id.

  14..15 - origin: 2 bit reserved message origin indicator. For internal lifx use. Should be 0.

uint32_t source:
  Message source identifier from NAT table (Internal LIFX use)

*/
#pragma pack(push, 1)
typedef struct lx_frame_t {
  #define LX_FRAME_FIELDS   \
    uint16_t size;          \
    uint16_t protocol:12;   \
    uint8_t  addressable:1; \
    uint8_t  tagged:1;      \
    uint8_t  origin:2;      \
    uint32_t source;

  LX_FRAME_FIELDS
} lx_frame_t;
#pragma pack(pop)

/*

Level 1 - Frame with address.

+------+------------+--------+----+--------+------+-----------+---------+
| size | descriptor | source | id | target | site | reserved2 | payload |
+------+------------+--------+----+--------+------+-----------+---------+

Inherited from frame_t.

uint16_t size:
  As above.

uint16_t protocol/addressable/tagged:
  As above.

uint32_t source:
  As above.

uint8_t target[8]:
  Device or tag target within site.
  device: Target is a 6 byte value based on mac address of light [bytes 0-5].
  tag:    uint64_t bitmask of tag slots targetted. 0 matches all devices.

uint8_t site[6]:
  Site id is based on mac address of first light to claim site.

uint8_t:
  0       - Response required
  1       - Acknowledgement required
  2..7    - Reserved for future use.

uint8_t sequence:
  Wrap around sequence number (Reserved for LIFX use)

*/
#pragma pack(push, 1)
typedef struct lx_frame_address_t {
  #define LX_FRAME_ADDRESS_FIELDS \
    LX_FRAME_FIELDS           \
    uint8_t  target[8];       \
    uint8_t  site[6];         \
    uint8_t  res_required:1;  \
    uint8_t  ack_required:1;  \
    uint8_t  :6;              \
    uint8_t  sequence;

  LX_FRAME_ADDRESS_FIELDS
} lx_frame_address_t;
#pragma pack(pop)


/* INTERNAL LIFX USE */
#define LX_FRAME_ORIGIN_LAN  (0x00)
#define LX_FRAME_ORIGIN_PAN  (0x01)

/*

Level 2 - LIFX Protocol.

The LIFX message protocol.

+------+------------+----------+------+--------+---------+------+---------+
| size | descriptor | reserved | site | target | at_time | type | payload |
+------+------------+----------+------+--------+---------+------+---------+

*/
#pragma pack(push, 1)
typedef struct lx_protocol_t {
  LX_FRAME_ADDRESS_FIELDS
  uint64_t at_time;
  uint16_t type;
  uint8_t  reserved3[2];
  uint8_t  payload;	// This is primarily here so we can use offsetof(), don't use it for retrieving data
} lx_protocol_t;
#pragma pack(pop)
