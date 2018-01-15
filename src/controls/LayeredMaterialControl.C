// Mastodon includes
#include "LayeredMaterialControl.h"

template <>
InputParameters
validParams<LayeredMaterialControl>()
{
  InputParameters params = validParams<Control>();
  params.addRequiredParam<std::string>("parameter", "The name of the parameter to control.");
  params.addRequiredParam<std::vector<Real>>("values", "The values to replace on the specified material object.");
  return params;
}

LayeredMaterialControl::LayeredMaterialControl(const InputParameters & parameters)
  : Control(parameters),
  _current_values(getControllableValue<std::vector<Real>>("parameter")),
  _control_values(getParam<std::vector<Real>>("values"))
{
  if (_current_values.size() != _control_values.size())
    mooseError("The layer values specified in the ", name(), " Control object and the values being controlled must be the same size.");
}

void
LayeredMaterialControl::execute()
{
  setControllableValue<std::vector<Real>>("parameter", _control_values);
}
