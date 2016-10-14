classdef Constants
  properties(Constant)
    J = 1;
    T_crit = 2.269185314213022;
    BASE_DIR = fullfile(fileparts(mfilename('fullpath')), '..', '..');
    DB_DIR = fullfile(Constants.BASE_DIR, 'db');
    PLOTS_DIR = '~/Documents/Natuurkunde/Scriptie/Plots/';
  end

  methods(Static)
    function T = T_pseudocrit(chi)
      pseudocritical_temps = [2.326643757577982, ...
       2.281132673943244, ...
       2.274369278752719, ...
       2.273518850874524, ...
       2.270977771936769, ...
       2.270884098490101, ...
       2.270172625973289, ...
       2.269902619868271, ...
       2.269503832589511, ...
       2.269407789655612];
      chi_values = [2, 4, 6, 8, 10, 12, 14, 16, 24, 32];
      map = containers.Map(chi_values, pseudocritical_temps);
      T = map(chi);
    end

    function t = reduced_T_dot(T, T_pseudocrit)
      t = (T - T_pseudocrit) / T_pseudocrit;
    end

    % Infinite system case
    function t = reduced_T(T)
      t = Constants.reduced_T_dot(T, Constants.T_crit);
    end

    function k = kappa()
      c = 1/2;
      k = 6 / (c*(1 + sqrt(12/c)));
    end

    function xi = correlation_length(T)
      xi = -1 / (log(sinh(2*(1/T))));
    end
  end
end
