function plot_tolerance
  temperatures = [Constants.T_crit];
  chi_values = [8, 16, 24, 32];
  N_values = [1000000];

  sim = FixedNSimulation(temperatures, chi_values, N_values);
  sim.SAVE_TO_DB = false; sim.LOAD_FROM_DB = false;

  figure
  set(gca,'YScale','log')
  hold on
  sim = sim.run();
  hold off

  xlabel('$N$')
  ylabel('Convergence')
  make_legend(chi_values, '\chi')

end
