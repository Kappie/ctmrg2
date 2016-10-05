classdef OrderParameter < Quantity
  methods(Static)
    function value = value_at(temperature, C, T)
      value = abs(Magnetization.value_at(temperature, C, T));
    end
  end
end
