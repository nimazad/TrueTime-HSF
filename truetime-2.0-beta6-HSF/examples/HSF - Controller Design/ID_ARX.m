function model = ID_ARX(HSFiddata, states)
    na = ones(states,states); nb = ones(states,2); nk =zeros(states,2);
    m_arx = arx(HSFiddata, [na nb nk]);
    marx = idss(m_arx);
    model = ssform(marx, 'Form', 'free', 'Feedthrough', false, 'DisturbanceModel', 'none');
end