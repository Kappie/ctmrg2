classdef Magnetization < Quantity
  methods(Static)
    function value = value_at(temperature, C, T)
      display('square lattice')
      Z = Util.partition_function(temperature, C, T)
      unnormalized_magnetization = Util.attach_environment(Util.construct_b(temperature), C, T)
      value = unnormalized_magnetization / Z;
    end
  end
end
