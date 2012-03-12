# Configuration file for the Ocean Assimilation Kit (OAK)
# http://modb.oce.ulg.ac.be/mediawiki/index.php/Ocean_Assimilation_Kit
#
# Lines starting with # or ! are comments.
# See comments at the end of this file.


Config.exec = '~/Assim/OAK/assim-gfortran-single'
#Config.calendar = 'standard'
#Config.time_origin  = '0001-01-01T00:00:00'



# State vector definition

Model.variables     = [          'var1',          'var2']
Model.gridX         = [ 'domain.nc#lon', 'domain.nc#lon']
Model.gridY         = [ 'domain.nc#lat', 'domain.nc#lat']
Model.gridZ         = [   'domain.nc#z',   'domain.nc#z']
Model.mask          = ['domain.nc#mask','domain.nc#mask']
Model.path          = 'Common/'

# Error space of the state vector

ErrorSpace.dimension = 10
ErrorSpace.path      = './'
ErrorSpace.init      = ['("Ens",I3.3,"/model.nc#var1")','("Ens",I3.3,"/model.nc#var2")']
ErrorSpace.type      = 2

# runtype = integer: possible values of runtype are:
#   0 = do nothing, i.e. a pure run of the model 
#   1 = still do not assimilate, but compare model to observations
#   2 = assimilate observations

runtype = 2

# schemetype = integer: possible values of schemetype are:
#   possible values of "schemetype" are:
#   0 = global assimilation (default)
#   1 = local assimilation

schemetype = 0

Zones.partition        = ['domain.nc#part','domain.nc#part']
Zones.corrLength.const = [           30e3,             30e3]
Zones.maxLength.const  = [         2000e3,           2000e3]
Zones.path = 'Common/'

 
# logfile contains simple diagnostics such as RMSE with observations

logfile = 'assim.log'
debugfile = 'assim.debug'


#------------------------------------------------------------------------------------
#
# observations

Obs001.time      = '2010-07-06T00:30:00'
Obs001.path      = 'Obs/'
Obs001.variables  = [              'var1']
Obs001.names      = [      'var1_surface']
Obs001.gridX      = [       'obs1.nc#lon']
Obs001.gridY      = [       'obs1.nc#lat']
Obs001.gridZ      = [         'obs1.nc#z']
Obs001.value      = [      'obs1.nc#var1']
Obs001.mask       = [      'obs1.nc#var1']
Obs001.rmse       = [      'obs1.nc#rmse']


Obs002.time      = '2010-07-06T00:30:00'
Obs002.path      = 'Obs/'
Obs002.variables  = [              'var1']
Obs002.names      = [      'var1_surface']
Obs002.gridX      = [       'obs1.nc#lon']
Obs002.gridY      = [       'obs1.nc#lat']
Obs002.gridZ      = [         'obs1.nc#z']
Obs002.value      = [      'obs1.nc#var1']
Obs002.mask       = [      'obs1.nc#var1']
Obs002.rmse       = [      'obs1.nc#rmse']

# diagnostics

# common declaration for all observations

Diag*.stddevxf  =  ['stddevxf.nc#var1','stddevxf.nc#var2']
Diag*.stddevxa  =  ['stddevxa.nc#var1','stddevxa.nc#var2']
Diag*.xf        =  ['forecast.nc#var1','forecast.nc#var2']
Diag*.xa-xf     =  [     'inc.nc#var1',     'inc.nc#var2']
Diag*.Ea      = ['("../Ens",I3.3,"/model_an.nc#var1")','("../Ens",I3.3,"/model_an.nc#var2")']


Diag001.Hxf       = [       'diag1.nc#xf']
Diag001.Hxa       = [       'diag1.nc#xa']
Diag001.yo        = [       'diag1.nc#yo']
Diag001.invsqrtR  = [ 'diag1.nc#invsqrtR']
Diag001.stddevHxf = ['diag1.nc#stddevHxf']
Diag001.stddevHxa = ['diag1.nc#stddevHxa']
Diag001.path   = 'Analysis001/'
Diag002.path   = 'Analysis002/'

# Analysis

Analysis*.value =  ['analysis.nc#var1','analysis.nc#var2']
Analysis001.path  =  'Analysis001/'



# State vector definition
#
# Model.variables = vector of strings. Each string a the name of the variable.
#
# Model.gridX = vector of strings. Each string is a file name containing 
#   the longitude of the corresponding variable.
#
# Model.gridY = vector of strings. Each string is a file name containing 
#   the latitude of the corresponding variable.
#
# Model.gridZ = vector of strings. Each string is a file name containing 
#   the depth of the corresponding variable.
#
# Model.mask = vector of strings. Each string is a file name containing 
#   the binary mask of the corresponding variable. Only values where the mask is different
#   from the FillValue_ attribute are include in the state vector
#
# Model.path = 'where/can/I/find/the/files/'

#
# Error space of the state vector
#
# ErrorSpace.dimension = integer: Number of ensemble members/EOFs
#
# ErrorSpace.init = vector of strings. Each string is a Fortran format expression. For the ith ensemble member/EOF, 
#   the file name is obtained by:
#   write(filename,format) i
#
# ErrorSpace.type = integer: possible value of ErrorSpace.type are:
#   1 = Error Space is given as EOF mode
#   2 = Error Space is represented as an ensemble

#
# Zone for local assimilation scheme
#
# Zones.partition = vector of strings. Each string is a file name containing 
#   the zone file of the corresponding variable. The zone files contains an 
#   array of integers (fractional parts are ignored). Variables are in the same 
#   zone if the same integer is associated to them. 
#
# Zones.corrLength = vector of strings. Each string is a file name containing 
#   the correlation length of the corresponding variable.
#
# Zones.corrLength.const = vector of reals. Each real value is the constant 
#   correlation length of the corresponding variable.
#
# Zones.maxLength = vector of strings. Each string is a file name containing 
#   the maximum correlation length of the corresponding variable.
#
# Zones.maxLength.const = vector of reals. Each real value is the constant 
#   maximum correlation length of the corresponding variable.
#
# Zones.path = string. Path where all files for the zone definition can be found

# Observation
#
# XXX = time index of the observation
# IMPORTANT: Observations must by ordered chronologically
#
# ObsXXX.time = 'YYYY-MM-DDThh:mm:ss[.ss]'
#   YYYY=year  (4 digits integer)
#   MM=month (2 digits integer)
#   DD=day   (2 digits integer)
#   hh=hour (2 digits integer)
#   mm=min  (2 digits integer)
#   ss=second (minimum 1 digit integer or real)
#   
# ObsXXX.path = 'where/can/I/find/the/files/'
#
# ObsXXX.variables = vector of strings. The names must correspond to the names 
#   chosen in Model.variables. Unknown names are treated as "out of the grid"
#   and are not assimilated.
#
# ObsXXX.value = vector of strings. Each string is a file name containing
#   the actual values of the observations
#
# ObsXXX.gridX = vector of strings. Each string is a file name containing 
#   the longitude of the observations.
#
# ObsXXX.gridY = vector of strings. Each string is a file name containing 
#   the latitude of the observations.
#
# ObsXXX.gridZ = vector of strings. Each string is a file name containing 
#   the depth of the observations.
#
# ObsXXX.rmse = vector of strings. Each string is a file name containing 
#   the root mean square error of the observations.
#
# ObsXXX.mask = vector of strings. Each string is a file name containing 
#   the binary mask of the observations. Values where the mask is different
#   from 1 are rejected.
#
# ObsXXX.operator = file name. (OPTIONAL) The observation operator stored in a 
#    sparse matrix form. If this file is given ObsXXX.gridX, Y and Z are not
#    used.
#    This matrix contains as many lines as they exist unmasked observation.
#    Each line has the following 9 columns:
#    
#    |Obs. |Obs.   |Obs.   |Obs.   ||Model|Model  |Model  |Model  || Interpo-
#    |var. |i-index|j-index|k-index||var. |i-index|j-index|k-index|| lation
#    |index|       |       |       ||index|       |       |       || coefficient
#
#    Observation variable index is the position where the observed variable appears 
#    in ObsXXX.variables. 
#    Model variable index is the position where the observed variable appears 
#    in Model.variables. If one of the model indexes is -1 the corresponding
#    observation is treated "out of grid".
#
#    The observation operator can be generated using a trilinear interpolation 
#    with the tool "genobsoper".

# Diagnostics
#
# DiagXXX.stddevxf  = vector of strings. Error standard deviation of forecast
#
# DiagXXX.stddevxa  = vector of strings. Error standard deviation of analysis
#
# DiagXXX.xf        = vector of strings. Forecast
#
# DiagXXX.xa-xf     = vector of strings. Analysis increment
#
# DiagXXX.Hxf       = vector of strings. Forecast at observation location
#
# DiagXXX.Hxa       = vector of strings. Analysis at observation location
#
# DiagXXX.yo        = vector of strings. Observation used during assimilation
#
# DiagXXX.invsqrtR  = vector of strings. inverse of the square root of diagonal 
#   elements of the observation error covariance matrix
#
# DiagXXX.stddevHxf = vector of strings. Error standard deviation of forecast
#   at observation location
#
# DiagXXX.stddevHxa = vector of strings. Error standard deviation of analysis
#   at observation location
#
# DiagXXX.path   = string. Path where all files for the diagnostics can be found
