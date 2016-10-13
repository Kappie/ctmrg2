function tensor_struct = find_or_calculate_environment(obj, temperature, chi, tolerance)
  % I look for all records with the same temperature, same chi and greater or equal tolerance.
  % If I find an exact match (same temperature, chi, tolerance as I'm trying to simulate)
  % I do not simulate again.
  % If I find a record with matching temperature and chi and higher tolerance
  % I select the C, T from that record to use as initial C, T for the new simulation.
  fprintf(['searching database for: \n' ...
    'temperature = ' num2str(temperature) ...
    ', chi = ' num2str(chi) ...
    ', convergence = ' num2str(tolerance) '\n'])

  query = ['SELECT * ' ...
    'FROM tensors ' ...
    'WHERE temperature = ? AND chi = ? AND convergence >= ? ' ...
    'ORDER BY convergence ASC ' ...
    'LIMIT 1'];
  query_result = sqlite3.execute(obj.db_id, query, temperature, chi, tolerance);

  if isempty(query_result) || ~obj.LOAD_FROM_DB
    display('Did not find a matching record.');
    initial_C = obj.initial_C(temperature);
    initial_T = obj.initial_T(temperature);
    [C, T, convergence, N, converged] = obj.calculate_environment(temperature, chi, tolerance, initial_C, initial_T);
    simulated = true;
  else
    if query_result.chi == chi & query_result.convergence == tolerance
      display('Found a matching record.')
      [C, T] = Util.deserialize_tensors(query_result);
      simulated = false;
    else
      fprintf(['Found a record with higher tolerance to use as initial condition\n' ...
        'chi = ' num2str(query_result.chi) ...
        ', convergence = ' num2str(query_result.convergence) ...
        ', N = ' num2str(query_result.n) '\n'])
      [initial_C, initial_T] = Util.deserialize_tensors(query_result);
      [C, T, convergence, additional_N, converged] = obj.calculate_environment(temperature, chi, tolerance, initial_C, initial_T);
      fprintf(['I did an additional ' num2str(additional_N) ' steps.\n'])
      N = query_result.n + additional_N;
      simulated = true;
    end
  end

  if simulated && converged
    obj.save_to_db(temperature, chi, N, tolerance, C, T);
  end

  tensor_struct = struct('C', C, 'T', T);
end
