classdef FixedNSimulation < Simulation
  properties
    N_values;
  end

  methods
    function obj = FixedNSimulation(temperatures, chi_values, N_values)
      obj = obj@Simulation(temperatures, chi_values);
      obj.N_values = N_values;
      obj = obj.after_initialization();
    end
  end
end
