@testset "Solved R 0 From Heat Function Tests" begin

  @test isdefined(Tokamak, :solved_R_0_from_heat) == true

  Tokamak.load_input( "h_parallel = $( Tokamak.max_h_parallel / ( 1u"MW" / 1u"m^2" ) ) * ( 1u\"MW\" / 1u\"m^2\" )" )
  Tokamak.load_input( "T_k = 15u\"keV\"" )

  actual_value = Tokamak.solved_R_0_from_heat()
  actual_value /= 1u"m"

  eq_1 = Tokamak.r_b_eq_hard_coded()
  eq_2 = Tokamak.r_b_eq_from_heat_loading()

  eq_1 = Tokamak.calc_possible_values(eq_1)
  eq_2 = Tokamak.calc_possible_values(eq_2)

  cur_R_0 = Tokamak.symbol_dict["R_0"]
  cur_B_0 = Tokamak.symbol_dict["B_0"]

  solved_system = solve([eq_1, eq_2], [cur_R_0, cur_B_0])

  expected_value = solved_system[1][cur_R_0]

  expected_value = SymPy.N(expected_value)

  @test isapprox(expected_value, actual_value, rtol=5e-3)

end
