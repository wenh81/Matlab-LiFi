%% Read received file from oscilloscope
Rx = Tx;

%% Find and compensate for the delay between TX and RX
% Upsample the TX data to match RX sampling rate
TxUpsampled = resample(Tx,Rx.Time);

% Retrieve preamble from TX data
PreambleIndices = find(TxUpsampled.Time<SimDuration/NbOFDMSymbols);
Preamble = timeseries(TxUpsampled.Data(PreambleIndices),TxUpsampled.Time(PreambleIndices));

% Find delay between TX and RX using correlation
u(:) = Preamble.Data(1,1,:);
v(:) = Rx.Data(1,1,:);
delay = abs(finddelay(u, v));

% Compensate for the delay by shifting RX signal
shiftedRxData = Rx.Data(:,:,delay+1:length(Rx.Data));
shiftedRxTime = Rx.Time(delay+1:length(Rx.Time),:);
Rx = timeseries(shiftedRxData, shiftedRxTime);

%% Resample the RX data to match the original TX sampling rate
Rx = resample(Rx,Tx.Time);