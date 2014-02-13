function model = ID_ssset(HSFiddata, states, samplingTime)
    model = ssest(HSFiddata, states, 'Ts', samplingTime, 'DisturbanceModel', 'none', 'Form', 'canonical');
end