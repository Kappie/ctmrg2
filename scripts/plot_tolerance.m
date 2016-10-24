function plot_tolerance
  chi = 16;
  temperatures = [Constants.T_pseudocrit(chi)];
  chi_values = [chi];
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
