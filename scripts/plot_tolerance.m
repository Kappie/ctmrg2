function plot_tolerance
  temperatures = [Constants.T_crit];
  chi_values = [64];
  N_values = [1000000];

  sim = FixedNSimulation(temperatures, chi_values, N_values);
  sim.SAVE_TO_DB = false; sim.LOAD_FROM_DB = false;
  sim = sim.run();

end
