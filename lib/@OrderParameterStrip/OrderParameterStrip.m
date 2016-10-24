classdef OrderParameterStrip < Quantity
  methods(Static)
    function value = value_at(temperature, C, T)
      value = abs(MagnetizationStrip.value_at(temperature, C, T));
    end
  end
end
