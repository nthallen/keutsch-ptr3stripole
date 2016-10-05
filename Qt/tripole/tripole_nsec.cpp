#include "tripole_nsec.h"
#include "nortlib.h"

tripole_nsec::tripole_nsec(uint16_t addr_in, QLabel *lbl) {
  addr = addr_in;
  QO = lbl;
  write_pending = false;
  read_pending = false;
  QO->setText("");
}

tripole_nsec::~tripole_nsec() {}

/**
 * @brief tripole_nsec::ready
 * Slot to signal that a subbus request has completed.
 * In our case, that is either a read (SBC_READACK) or
 * write (SBC_WRITEACK). If it was a read, then we need
 * to pick up the value and use it. If it was a write,
 * no further action is required. In either case, if
 * there is a pending operation, that should be initiated.
 */
void tripole_nsec::ready() {
  switch (command) {
    case SBC_READACK:
      switch (cmd_status) {
        case SBS_ACK:
          current_value = ((reply_data.read_data)>>4)*10 +
              (reply_data.read_data & 0xF);
          QO->setNum(current_value);
          break;
        case SBS_NOACK:
          nl_error(1, "No acknowledge reading from %04X",
                   request_data.d1.data);
          break;
        case SBS_TIMEOUT:
          nl_error(1, "Subbus timeout reading from %04X",
                   request_data.d1.data);
          break;
        default:
          nl_error(2, "Unexpected subbus response %d reading from %04X",
                   cmd_status, request_data.d1.data);
          break;
      }
      break;
    case SBC_WRITEACK:
      switch (cmd_status) {
        case SBS_ACK:
          break;
        case SBS_NOACK:
          nl_error(1, "No acknowledge writing to %04X",
                   request_data.d0.address);
          break;
        case SBS_TIMEOUT:
          nl_error(1, "Subbus timeout writing to %04X",
                   request_data.d0.address);
          break;
        default:
          nl_error(2, "Unexpected subbus response %d writing to %04X",
                   cmd_status, request_data.d0.address);
          break;
      }
      break;
    default:
      nl_error(4,"Unexpect command value in tripole_nsec::ready()");
  }
  if (req_status == SBDR_IDLE) {
    if (read_pending) {
      read(addr);
      read_pending = false;
    } else if (write_pending) {
      write(addr, pending_value);
      write_pending = false;
    }
  }
}

void tripole_nsec::acquire() {
  if (req_status == SBDR_IDLE) {
    read(addr);
    read_pending = false;
  } else {
    read_pending = true;
  }
}

/**
 * @brief tripole_nsec::set
 * @param nsec
 * Converts nsec to the raw format and queues it for output
 */
void tripole_nsec::set(int nsec) {
  if (nsec < 0) nsec = 0;
  else if (nsec >= 0x1000 * 10) {
    nsec = 10*0xFFF + 9;
  }
  pending_value = ((nsec/10)<<4) + (nsec%10);
  if (req_status == SBDR_IDLE) {
    write(addr, pending_value);
    write_pending = false;
  } else {
    write_pending = true;
  }
}

QString tripole_nsec::getName() {
  return QO->objectName();
}

uint16_t tripole_nsec::getValue() {
  return current_value;
}
