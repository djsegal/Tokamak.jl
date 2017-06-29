# skip: true

@testset "R B Eq From Ignition Function Tests" begin

  @test isdefined(Tokamak, :r_b_eq_from_ignition) == true

  expected_value = Tokamak.K_PB_legacy()

  actual_value = Tokamak.r_b_eq_from_ignition()

  actual_value += Tokamak.symbol_dict["R_0"]

  actual_value ^= 16 // 100

  actual_value *= Tokamak.symbol_dict["K_CD_denom"] ^ ( 96 // 100 )

  actual_value *= Tokamak.symbol_dict["sigma_v_hat"] ^ ( 69 // 100 )

  actual_value = collect(actual_value, Tokamak.symbol_dict["B_0"] )

  actual_value /= Tokamak.symbol_dict["B_0"] ^ ( 15 // 100 )

  actual_value *= Tokamak.symbol_dict["T_k"] ^ ( 4 // 100 )

  cur_numerator = -Tokamak.K_nu()
  cur_numerator *= ( Tokamak.symbol_dict["T_k"] ) ^ ( 1//2 )
  cur_numerator += Tokamak.symbol_dict["sigma_v_hat"]

  actual_value /= cur_numerator

  test_count = 4

  for cur_bool in [false, true]

    if cur_bool
      test_count = Int(round( test_count / 2 ))
      Tokamak.load_input("random.jl", true)
    end

    for cur_T_k in logspace(3, 5, test_count)
      Tokamak.load_input( "T_k = $(cur_T_k)u\"keV\"" )

      cur_actual_value = Tokamak.calc_possible_values(actual_value)

      @test isapprox(cur_actual_value, expected_value, rtol=1e-1)
    end

  end

end
