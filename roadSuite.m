function roads = roadSuite(stopTime, dt) % (total duration, time between each sample)
if isempty(stopTime)
    stopTime = 10;
end
if  isempty(dt)
    dt = 0.001;
end
%makes sure values are scalar
validateattributes(stopTime, {'numeric'}, ...
    {'scalar','real','finite','positive'}, mfilename, 'stopTime');
validateattributes(dt, {'numeric'}, ...
    {'scalar','real','finite','positive'}, mfilename, 'dt');

t = (0:dt:stopTime).'; %time

if t(end) < stopTime
    t(end+1,1) = stopTime;
end





%speed bump
speedBump = raisedCosinePulse(t, 1.0, 0.80, 0.050);

% pothole
pothole = raisedCosinePulse(t, 1.0, 0.65, -0.040);

%bumpy road
rng(15);
rawNoise = randn(size(t));
zRough = movmean(rawNoise, 20) - movmean(rawNoise, 500);
zRough = zRough - mean(zRough);
fade = min(max((t - 0.5) / 0.5, 0), 1);
zRough = zRough .* fade;
steadyPart = t >= 1.0;
currentRms = sqrt(mean(zRough(steadyPart).^2));

if currentRms > 0
    zRough = zRough * (0.004 / currentRms);
end

% two bumps
twoBumps = raisedCosinePulse(t, 1.0, 0.65, 0.040) ...
          + raisedCosinePulse(t, 4.0, 0.65, 0.040);

%outputs
roads.time = t;
roads.units = 'm';

roads.speedBump = timeseries(speedBump, t, ...
    'Name', 'Speed bump');

roads.pothole = timeseries(pothole, t, ...
    'Name', 'Pothole');

roads.roughRoad = timeseries(zRough, t, ...
    'Name', 'Rough road');

roads.twoBumps = timeseries(twoBumps, t, ...
    'Name', 'Two bumps');
roads.caseNames = { ...
    'speedBump', ...
    'pothole', ...
    'roughRoad', ...
    'twoBumps'};
end

function roadConditions = raisedCosinePulse(t, startTime, duration, amplitude)

roadConditions = zeros(size(t));
mask = t >= startTime & t <= startTime + duration;
normalizedTime = ...
    (t(mask) - startTime) / duration;
roadConditions(mask) = 0.5 * amplitude .* ...
    (1 - cos(2*pi*normalizedTime));
end