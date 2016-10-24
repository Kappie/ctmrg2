function test_order_param_strip2
  width = 10;
  temperatures = [Constants.T_crit + width];
  reduced_temperatures = Constants.reduced_Ts(temperatures)
  chi_values = [2];
  % tolerances = [1e-8];
  % N_values = 100:500:100100;
  N_values = [500];

  global number_of_eigvals;
  global eigenvalues;
  number_of_eigvals = 2;
  eigenvalues = zeros(0, number_of_eigvals);

  sim = FixedNSimulation(temperatures, chi_values, N_values);
  sim = sim.run();
  order_params = sim.compute(OrderParameter)
  order_params_strip = sim.compute(OrderParameterStrip)
  diffs_order_param = (order_params - order_params_strip) ./ order_params;
  diffs_eigenvalues = (eigenvalues(:, 1) - eigenvalues(:, 2)) ./ eigenvalues(:, 1);

  markerplot(N_values, eigenvalues);
  % xlabel('$N$');
  % ylabel('$(m_{\mathrm{square}} - m_{\mathrm{strip}}) / m_\mathrm{square}$');
  % ylabel('$(m - m_{\mathrm{exact}}) / m_{\mathrm{exact}}$')
  % title(['$t = ' num2str(reduced_temperatures(1), 2) '$, $\chi = ' num2str(chi_values(1)) '$'])
  % make_legend(chi_values, '\chi')
  % title('$T = T_c + 0.01$')
  % legend({'$N \times N$ lattice', '$N \times \infty$ lattice'})


end
