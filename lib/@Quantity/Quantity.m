classdef (Abstract) Quantity
% Every quantity must respond to value_at(temperature, C, T).
% A quantity is computed by a simulated environment , like this:
% simulation = FixedNSimulation(temperatures, chi_values, N_values);
% simulation.compute(quantity)

  methods(Static)
    value = value_at(temperature, C, T);
  end
end
