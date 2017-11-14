[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  beta = 0.25
  gamma = 0.5
[]

[Mesh]
  type = FileMesh
  file = 'soil_column.e'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[AuxVariables]
  [./vel_x]
  [../]
  [./accel_x]
  [../]
  [./vel_y]
  [../]
  [./accel_y]
  [../]
  [./vel_z]
  [../]
  [./accel_z]
  [../]
  [./layer_id]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./DynamicTensorMechanics]
    zeta = 1.5725e-05
  [../]
  [./inertia_x]
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    eta = 0.075175
  [../]
  [./inertia_y]
    type = InertialForce
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    eta = 0.075175
  [../]
  [./inertia_z]
    type = InertialForce
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    eta = 0.075175
  [../]
  [./gravity]
    type = Gravity
    block = '1 2'
    variable = disp_z
    value = -32.2
  [../]
[]

[AuxKernels]
  [./accel_x]
    type = NewmarkAccelAux
    variable = accel_x
    displacement = disp_x
    velocity = vel_x
    execute_on = timestep_end
  [../]
  [./vel_x]
    type = NewmarkVelAux
    variable = vel_x
    acceleration = accel_x
    execute_on = timestep_end
  [../]
  [./accel_y]
    type = NewmarkAccelAux
    variable = accel_y
    displacement = disp_y
    velocity = vel_y
    execute_on = timestep_end
  [../]
  [./vel_y]
    type = NewmarkVelAux
    variable = vel_y
    acceleration = accel_y
    execute_on = timestep_end
  [../]
  [./accel_z]
    type = NewmarkAccelAux
    variable = accel_z
    displacement = disp_z
    velocity = vel_z
    execute_on = timestep_end
  [../]
  [./vel_z]
    type = NewmarkVelAux
    variable = vel_z
    acceleration = accel_z
    execute_on = timestep_end
  [../]
  [./layer_id]
     type = UniformLayerAuxKernel
     block = '1 2'
     variable = layer_id
     interfaces = '4.667 40.667 139.667 168.667 221.667 240.667 260.667'
     direction = '0.0 0.0 1.0'
     execute_on = initial
  [../]
[]


[BCs]
  [./SeismicForce]
    [./input_velocities]
       displacements = 'disp_x disp_y disp_z'
       input_components = '0 1 2'
       boundary = '1'
       velocity_functions = 'v1100 v1101 v1102'
    [../]
  [../]
  [./NonReflectingBC]
     [./bottom]
       displacements = 'disp_x disp_y disp_z'
       velocities = 'vel_x vel_y vel_z'
       accelerations = 'accel_x accel_y accel_z'
       beta = 0.25
       gamma = 0.5
       boundary = '1'
     [../]
   [../]
  [./Periodic]
    [./periodic_x]
      variable = 'disp_x disp_y disp_z'
      primary = '3'
      secondary = '2'
      translation = '25 0 0'
    [../]
    [./periodic_y]
      variable = 'disp_x disp_y disp_z'
      primary = '5'
      secondary = '4'
      translation = '0 25 0'
    [../]
  [../]
[]

[Materials]
  [./I_Soil]
    [./soil_1]
      block = 1
      soil_type = 1
      layer_variable = layer_id
      layer_ids = '0 1 2 3 4 5 6'
      poissons_ratio = '0.273 0.273 0.314 0.313 0.384 0.210 0.219'
      initial_soil_stress = 'init_stress 0 0 0 init_stress 0 0 0 init_stress'
      density = '0.0031045 0.0031045 0.0031045 0.0031045 0.0031045 0.0031045 0.0031045'
      pressure_dependency = false
      b_exp = 0.0
      tension_pressure_cut_off = -1e-9
      p_ref = '24.3906  24.3906  17.33937  10.63772  6.54245  2.9466  0.99885'
      a0 = 0.0
      a1 = 0.0
      a2 = 1.0
      ### Darendeli ###
      number_of_points = 10
      initial_bulk_modulus = '13576.654 13576.654  25546.87  12559.28  15491.749  21132.08  5236.278'
      initial_shear_modulus = '0.7263e4    0.7263e4    1.0849e4    0.5366e4    0.3895e4    1.5194e4    0.3621e4'
      over_consolidation_ratio = '1.0 1.0 1.0 1.0 1.0 1.0 1.0'
      plasticity_index = '1.0 1.0 1.0 1.0 1.0 1.0 1.0'
      #wave_speed_calculation = 'false'
      ######
    [../]
  [../]
  [./Elastic_bottom]
    type = ComputeIsotropicElasticityTensorSoil
    block = '2'
    layer_variable = 'layer_id'
    layer_ids = '0 1 2 3 4 5 6'
    shear_modulus = '51898.180 51898.180 51898.180 51898.180 51898.180 51898.180 51898.180'
    poissons_ratio = '0.0871644 0.0871644 0.0871644 0.0871644 0.0871644 0.0871644 0.0871644'
    density = '0.0032985 0.0032985 0.0032985 0.0032985 0.0032985 0.0032985 0.0032985'
  [../]
  [./strain_bottom]
    type = ComputeSmallStrain
    block = '2'
    displacements = 'disp_x disp_y disp_z'
  [../]

  [./stress_bottom]
    type = ComputeLinearElasticStress
    store_stress_old = true
    block = '2'
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '201                hypre    boomeramg      4'
  line_search = 'none'
  start_time = 0.0
  end_time = 40.95875
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  l_tol = 1e-6
  timestep_tolerance = 1e-10
  dt = 0.00125
[]

[Functions]
  [./v1100]
    type = PiecewiseLinear
    data_file = 'input_v1100.csv'
    format = 'columns'
    scale_factor = 1.0
  [../]
  [./v1101]
    type = PiecewiseLinear
    data_file = 'input_v1101.csv'
    format = 'columns'
    scale_factor = 1.0
  [../]
  [./v1102]
    type = PiecewiseLinear
    data_file = 'input_v1102.csv'
    format = 'columns'
    scale_factor = 1.0
  [../]
  [./init_stress]
    type = PiecewiseLinear
    data_file = 'ICs_input.csv'
    format = 'columns'
    scale_factor = '1.0'
  [../]
[]

#[VectorPostprocessors]
#  [./accel_hist]
#    type = ResponseHistoryBuilder
#    variables = 'accel_x'
#    node = 402
#    execute_on = 'initial timestep_end'
#  [../]
#  [./accel_spec]
#    type = ResponseSpectraCalculator
#    vectorpostprocessor = accel_hist
#    variables = 'accel_x'
#    damping_ratio = 0.05
#    dt_output = 0.001
#    calculation_time = 4.7
#    execute_on = timestep_end
#  [../]
#[]

[Postprocessors]
  [./_dt]
    type = TimestepSize
  [../]
  [./ACC_top_x]
    type = PointValue
    point = '12.5 12.5 260.667'
    variable = accel_x
  [../]
  [./ACC_top_y]
    type = PointValue
    point = '12.5 12.5 260.667'
    variable = accel_y
  [../]
  [./ACC_top_z]
    type = PointValue
    point = '12.5 12.5 260.667'
    variable = accel_z
  [../]
  [./VEL_top_x]
    type = PointValue
    point = '12.5 12.5 260.667'
    variable = vel_x
  [../]
  [./VEL_top_y]
    type = PointValue
    point = '12.5 12.5 260.667'
    variable = vel_y
  [../]
  [./VEL_top_z]
    type = PointValue
    point = '12.5 12.5 260.667'
    variable = vel_z
  [../]
  [./DISP_top_x]
    type = PointValue
    point = '12.5 12.5 260.667'
    variable = disp_x
  [../]
  [./DISP_top_y]
    type = PointValue
    point = '12.5 12.5 260.667'
    variable = disp_y
  [../]
  [./DISP_top_z]
    type = PointValue
    point = '12.5 12.5 260.667'
    variable = disp_z
  [../]
  [./num_its]
    type = NumNonlinearIterations
  [../]
[]

[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = true
  print_perf_log = true
  file_base = out
  [./out]
    type = Console
    interval = 50
  [../]
[]
