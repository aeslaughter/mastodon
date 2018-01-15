#ifndef LAYEREDMATERIALCONTROL_H
#define LAYEREDMATERIALCONTROL_H

// MOOSE includes
#include "Control.h"

// Forward Declarations
class LayeredMaterialControl;

template <>
InputParameters validParams<LayeredMaterialControl>();

/**
 * A control for changing parameters associated with layer ids.
 */
class LayeredMaterialControl : public Control
{
public:
  LayeredMaterialControl(const InputParameters & parameters);

protected:
  virtual void execute() override;

  /// The values of the parameter to control
  const std::vector<Real> & _current_values;

  /// The values to use from this control
  const std::vector<Real> & _control_values;
};

#endif
