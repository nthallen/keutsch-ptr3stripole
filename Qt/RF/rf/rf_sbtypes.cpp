#include <QString>
#include <math.h>
#include "rf_sbtypes.h"
#include "rfWindow.h"

/* tmsbvar_run */
QString tmsbvar_run::convertedText(uint16_t raw_value) {
  return QString::fromLatin1((raw_value & 1) ? "On" : "Off");
}

/* tmsbvar_derived  */
tmsbvar_derived::tmsbvar_derived(tmsbvar *source) : tmsbvar(0) {
  this->source = source;
  connect(source, &tmsbvar::valueUpdated,
          this, &tmsbvar_ilock::sourceUpdated);
}

void tmsbvar_derived::sourceUpdated(bool fresh) {
  value = source->rawValue();
  emit valueUpdated(fresh);
}

/* tmsbvar_ilock */
QString tmsbvar_ilock::convertedText(uint16_t raw_value) {
  return QString::fromLatin1((raw_value & 4) ? "FAIL" : "OK");
}

/* tmsbvar_ns_lowres */
const double tmsbvar_ns_lowres::clk_period =
    (rfWindow::clkA_D*1e9)/(rfWindow::xtal_freq*rfWindow::clkA_M);
const int tmsbvar_ns_lowres::precision =
    (int) (1-floor(log10(clk_period)));

uint16_t tmsbvar_ns_lowres::unconvertValue(double conv_value) {
  return (uint16_t) floor(conv_value/clk_period + 0.5);
}

double tmsbvar_ns_lowres::convertedValue(uint16_t raw_value) {
  return raw_value*clk_period;
}

QString tmsbvar_ns_lowres::convertedText(uint16_t raw_value) {
  return QString::number(convertedValue(raw_value),'f',precision);
}

void tmsbvar_ns_lowres::setupSpin(QDoubleSpinBox *cmd) {
  cmd->setDecimals(precision);
  cmd->setSingleStep(clk_period);
  cmd->setMinimum(0);
  cmd->setMaximum(200);
}

/* tmsbvar_mhz */
double tmsbvar_mhz::convertedValue(uint16_t raw_value) {
  return raw_value > 0 ? 1e3/source->convertedValue(raw_value) : 0;
}

/* tmsbvar_ns_hires */
tmsbvar_ns_hires::tmsbvar_ns_hires(uint16_t address, bool adjustable)
    : tmsbvar(address) {
  this->adjustable = adjustable;
  phase_res = rfWindow::clkB_M*56; // This could be static
  clk_period =
      (rfWindow::clkA_D*1e9) /
      (rfWindow::xtal_freq * rfWindow::clkA_M *
       (adjustable?phase_res:1));
  precision = (int) (1-floor(log10(clk_period)));
  phase_mask = (1<<rfWindow::phase_bits)-1; // This could be static
}

uint16_t tmsbvar_ns_hires::unconvertValue(double conv_value) {
  uint16_t fineclks = (uint16_t) floor(conv_value/clk_period + 0.5);
  uint16_t fine = adjustable ? (fineclks%phase_res) : 0;
  uint16_t clks = fineclks/phase_res;
  uint16_t raw_value = (clks<<rfWindow::phase_bits) + fine;
  return raw_value;
}

double tmsbvar_ns_hires::convertedValue(uint16_t raw_value) {
  uint16_t fine = raw_value & phase_mask;
  uint16_t clks = raw_value >> rfWindow::phase_bits;
  uint16_t fineclks = (clks*phase_res)+fine;
  return clk_period * fineclks;
}

QString tmsbvar_ns_hires::convertedText(uint16_t raw_value) {
  return QString::number(convertedValue(raw_value),'f',precision);
}

void tmsbvar_ns_hires::setupSpin(QDoubleSpinBox *cmd) {
  cmd->setDecimals(precision);
  cmd->setSingleStep(clk_period);
  cmd->setMinimum(0);
  cmd->setMaximum(200);
}
