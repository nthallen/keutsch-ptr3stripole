#ifndef RF_SBTYPES_H
#define RF_SBTYPES_H
#include "tmsbvar.h"

class tmsbvar_run : public tmsbvar {
public:
  tmsbvar_run(uint16_t address) : tmsbvar(address) {}
  ~tmsbvar_run() {}
  QString convertedText(uint16_t raw_value);
};

class tmsbvar_derived : public tmsbvar {
public:
  tmsbvar_derived(tmsbvar *source);
  ~tmsbvar_derived() {}
  void acquire() {}
public slots:
  void sourceUpdated(bool);
protected:
  tmsbvar *source;
};

class tmsbvar_ilock : public tmsbvar_derived {
public:
  tmsbvar_ilock(tmsbvar *src) : tmsbvar_derived(src) {}
  ~tmsbvar_ilock() {}
  QString convertedText(uint16_t raw_value);
};

class tmsbvar_ns_lowres : public tmsbvar {
public:
  tmsbvar_ns_lowres(uint16_t address) : tmsbvar(address) {}
  ~tmsbvar_ns_lowres() {}
  uint16_t unconvertValue(double conv_value);
  double convertedValue(uint16_t raw_value);
  QString convertedText(uint16_t raw_value);
  void setupSpin(QDoubleSpinBox *cmd);
private:
  static const double clk_period; // ns
  static const int precision;
};

class tmsbvar_mhz : public tmsbvar_derived {
public:
  tmsbvar_mhz(tmsbvar *src) : tmsbvar_derived(src) {}
  ~tmsbvar_mhz() {}
  double convertedValue(uint16_t raw_value);
};

class tmsbvar_ns_hires : public tmsbvar {
public:
  tmsbvar_ns_hires(uint16_t address, bool adjustable = true);
  ~tmsbvar_ns_hires() {}
  uint16_t unconvertValue(double conv_value);
  double convertedValue(uint16_t raw_value);
  QString convertedText(uint16_t raw_value);
  void setupSpin(QDoubleSpinBox *cmd);
private:
  bool adjustable;
  double clk_period; // ns
  int phase_res;
  int precision;
  uint16_t phase_mask;
};

#endif // RF_SBTYPES_H
