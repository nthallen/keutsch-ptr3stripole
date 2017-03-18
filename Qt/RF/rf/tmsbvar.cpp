#include <QString>
#include "tmsbvar.h"
#include "nortlib.h"

tmsbvar::tmsbvar(uint16_t addr) {
  address = addr;
  value = 0;
  fresh = false;
  read_pending = false;
  write_pending = false;
  read_queued = false;
  write_queued = false;
}

tmsbvar::~tmsbvar() {}

void tmsbvar::acquire() {
  if (read_pending || !fresh) {
    emit valueUpdated(false);
  }
  if (!read_pending) {
    if (write_pending) {
      read_queued = true;
    } else {
      read(address);
      read_pending = true;
    }
  }
  fresh = false;
}

void tmsbvar::ready() {
  switch (command) {
    case SBC_READACK:
      switch (cmd_status) {
        case SBS_ACK:
          value = reply_data.read_data;
          read_pending = false;
          fresh = true;
          Subbus_client::timed_out = false;
          emit valueUpdated(true);
          break;
        case SBS_NOACK:
          nl_error(1, "No acknowledge reading from %04X",
                   request_data.d1.data);
          read_pending = false;
          break;
        case SBS_TIMEOUT:
          if (!Subbus_client::timed_out) {
            Subbus_client::timed_out = true;
            nl_error(1, "Subbus timeout reading from %04X",
                     request_data.d1.data);
          }
          read_pending = false;
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
          write_pending = false;
          break;
        case SBS_NOACK:
          nl_error(1, "No acknowledge writing to %04X",
                   request_data.d0.address);
          write_pending = false;
          break;
        case SBS_TIMEOUT:
          if (!Subbus_client::timed_out) {
            Subbus_client::timed_out = true;
            nl_error(1, "Subbus timeout writing to %04X",
                     request_data.d0.address);
          }
          write_pending = false;
          break;
        default:
          nl_error(2, "Unexpected subbus response %d writing to %04X",
                   cmd_status, request_data.d0.address);
          break;
      }
      break;
    default:
      nl_error(4,"Unexpect command value in tmsbvar::ready()");
  }
  if (!read_pending && !write_pending) {
    if (read_queued) {
      read(address);
      read_queued = false;
      read_pending = true;
    } else if (write_queued) {
      write(address, wValue);
      write_queued = false;
      write_pending = true;
    }
  }
}

uint16_t tmsbvar::rawValue() {
  return value;
}

void tmsbvar::setRawValue(uint16_t rawValue) {
  if (read_pending || write_pending) {
    wValue = rawValue;
    write_queued = true;
  } else {
    write(address, rawValue);
    write_pending = true;
  }
}

void tmsbvar::setConvertedValue(double convValue) {
  setRawValue(unconvertValue(convValue));
}

double tmsbvar::convertedValue(uint16_t raw_value) {
  return((double) raw_value);
}

double tmsbvar::convertedValue() {
  return(convertedValue(value));
}

QString tmsbvar::convertedText() {
  return convertedText(value);
}

QString tmsbvar::convertedText(uint16_t raw_value) {
  return QString::number(convertedValue(raw_value));
}

uint16_t tmsbvar::unconvertValue(double conv_value) {
  return (uint16_t) conv_value;
}

void tmsbvar::setupSpin(QDoubleSpinBox *cmd) {
}
