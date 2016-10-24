function test_order_param_strip
  width = 10;
  number = 18;
  temperatures = [Constants.T_crit + width];
  % temperatures = linspace(Constants.T_crit - width, Constants.T_crit + width, number);
  % temperatures = Util.linspace_around_T_crit(width, number);
  chi_values = [8, 12, 16, 32, 64];
  % temperatures = arrayfun(@Constants.T_pseudocrit, chi_values);
  reduced_temperatures = Constants.reduced_Ts(temperatures);
  tolerances = [1e-7];


  % diffs = zeros(1, numel(chi_values));
  %
  % for c = 1:numel(chi_values)
  %   sim = FixedToleranceSimulation(temperatures(c), chi_values(c), tolerances).run();
  %   order_param = sim.compute(OrderParameter);
  %   order_param_strip = sim.compute(OrderParameterStrip);
  %   diffs(c) = (order_param - order_param_strip) / order_param;
  % end


  sim = FixedToleranceSimulation(temperatures, chi_values, tolerances).run();
  order_params_strip = sim.compute(OrderParameterStrip)
  order_params = sim.compute(OrderParameter)
  diffs = (order_params - order_params_strip) ./ order_params;

  markerplot(chi_values, diffs)
  % make_legend(chi_values, '\chi');
  make_legend_tolerances(tolerances);
  % vline(0, '--')
  xlabel('$\chi$')
  ylabel('$(m_{\mathrm{square}} - m_{\mathrm{strip}}) / m_{\mathrm{square}}$')
  title('$T = T_{c} + 10$')

  % make_legend_tolerances(tolerances)
end
