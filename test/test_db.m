function test_db
  test_db = 'test.db';
  clear_db;

  temperatures = [Constants.T_crit];
  chi_values = [2, 4];
  tolerances = [1e-4, 1e-6];
  N_values = [50, 100];

  fixed_N_sim = FixedNSimulation(temperatures, chi_values, N_values);
  fixed_tolerance_sim.DATABASE = 'test.db';
  fixed_N_sim = fixed_N_sim.run();

  fixed_tolerance_sim = FixedToleranceSimulation(temperatures, chi_values, tolerances);
  fixed_tolerance_sim.DATABASE = 'test.db';
  fixed_tolerance_sim = fixed_tolerance_sim.run;

  % fixed_N_sim = FixedNSimulation(temperatures, chi_values, [150]);
  % fixed_tolerance_sim.DATABASE = 'test.db';
  % fixed_N_sim = fixed_N_sim.run();

  function clear_db
    sqlite3.open(test_db);
    sqlite3.execute('delete from tensors;');
    sqlite3.close(test_db);
  end
end
