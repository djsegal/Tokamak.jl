function converge(cur_T_bar::AbstractFloat, tmp_dict::Dict)
  tmp_reactor = Reactor(cur_T_bar, tmp_dict)
  tmp_reactor.T_bar <= 0 && return []

  tmp_reactor.sigma_v = calc_sigma_v(tmp_reactor)
  isnan(tmp_reactor.sigma_v) && return []

  cur_func = function (cur_eta_CD::Number)
    cur_eta_CD = real(cur_eta_CD)

    cur_reactor = Reactor(cur_T_bar, tmp_dict)

    cur_reactor.eta_CD = cur_eta_CD

    solve!(cur_reactor)

    cur_reactor.is_good || return Inf

    tmp_eta_CD = calc_eta_CD(cur_reactor)

    isnan(tmp_eta_CD) && return Inf

    cur_equation = cur_eta_CD - tmp_eta_CD

    cur_equation
  end

  cur_root_list = find_zeros(
    cur_func, min_eta_CD, max_eta_CD,
    no_pts = no_pts_eta_CD, abstol = 1e-4
  )

  cur_root_list
end
