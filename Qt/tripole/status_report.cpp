#include "status_report.h"
#include "nortlib.h"

status_report::status_report(uint16_t addr_in, QLabel *Run, QLabel *Fail) {
  addr = addr_in;
  RunQL = Run;
  FailQL = Fail;
  read_pending = false;
  RunQL->setText("");
  RunVal = bool_blank;
  FailQL->setText("");
  FailVal = bool_blank;
}

status_report::~status_report() {}

/**
 * @brief status_report::ready
 * Slot to signal that a subbus request has completed.
 * In our case, that is a read (SBC_READACK), and we need
 * to pick up the value and use it. If
 * there is a pending operation, that should be initiated.
 */
void status_report::ready() {
  switch (command) {
    case SBC_READACK:
      switch (cmd_status) {
        case SBS_ACK:
          DisplayStatus(reply_data.read_data,1,RunQL,RunVal,"Off","On");
          DisplayStatus(reply_data.read_data,4,FailQL,FailVal,"OK","FAIL");
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
    default:
      nl_error(4,"Unexpect command value in tripole_nsec::ready()");
  }
  if (req_status == SBDR_IDLE) {
    if (read_pending) {
      read(addr);
      read_pending = false;
    }
  }
}

void status_report::acquire() {
  if (req_status == SBDR_IDLE) {
    read(addr);
    read_pending = false;
  } else {
    read_pending = true;
  }
}

void status_report::DisplayStatus(uint16_t value,uint16_t mask,QLabel *QL,
                   enum bool_display &disp,const char *false_text,
                   const char *true_text) {
  bool bitval = (value & mask);
  enum bool_display now = bitval ? bool_true : bool_false;
  if (now != disp) {
    QL->setText(bitval ? true_text : false_text);
    disp = now;
  }
}
