%% This is a the basic of components required to perform propagation
clear all; close all; %#ok<CLALL>
d2r = pi/180;

% Create the epoch object and set the initial epoch
date = AbsoluteDate();
date.SetJulianDate(2457473);

% Create the spacecraft state object and set Keplerian elements
state = OrbitState();
state.SetKeplerianState(6500,0.002,45*d2r,75*d2r,10*d2r,270*d2r);

% Create a spacecraft giving it a state and epoch
sat1 = Spacecraft(date,state);

% Create the propagator
prop = Propagator(sat1);

% Propagate for a duration and collect data
startDate = date.GetJulianDate();
count = 0;
for stepIdx = 1:86400/60
    
    % Propagate
    date.Advance(60);
    prop.Propagate(date);
    
end

%%  Comparison against truth below this line
orbState = sat1.GetOrbitState();
orbEpoch = sat1.GetOrbitEpoch();
jDate = orbEpoch.GetJulianDate();
gregDate = orbEpoch.GetGregorianDate();
kepState = orbState.GetKeplerianState();
kepState(3:6) = kepState(3:6)/d2r;

% This is generated by this propagator but agrees very well with STK J2
% analytic propagator
truthData =  [6500;
    0.002;
    45;
    68.4059136572242;
    16.9940847530552;
    116.731954192478]';

for i = 1:6
    if abs(kepState(i) - truthData(i)) > 1e-11
        error('Error in J2 Analytic Propagation')
    end
end





