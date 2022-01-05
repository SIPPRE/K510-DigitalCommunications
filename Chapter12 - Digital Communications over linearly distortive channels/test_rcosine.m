%this is a test to see the raised cosine (MATLAB / OCTAVE)

% To display the pulseshape, we oversample the signal by factor of f_ovsamp=8
f_ovsamp=8; %Oversampling factor vs data rate
delay_rc=5;
% Generating root-raised cosine pulseshape (rolloff factor = 0.5)
% Generating root-raised cosine pulseshape (roll-off factor = 0.5)

%next two lines for MATLAB
%prcos_M = rcosflt([1], 1, f_ovsamp, 'sqrt', 0.5, delay_rc);
%prcos_M=prcos_M(1:end-f_ovsamp+1);

%length of raised cosine is 2*f_ovsamp*delay_rc+1
%next two lines for OCTAVE
nsamp = 2*f_ovsamp*delay_rc; t_limits=[-nsamp/2,nsamp/2]/f_ovsamp ;  
prcos_O = rcosfir1(0.5, t_limits,f_ovsamp,1,'sqrt') ; 

plot(prcos_M) ; hold on ; plot(prcos_O,'r--')
