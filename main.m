% RWCPインパルス応答を使った畳み込みスクリプト

clear;
close all;

%%%%%%%%%%%%%%%%%%%%%%%% インパルス応答の設定 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
impName = "JR2";
srcPos(1) = "060";
srcPos(2) = "120"; % ポジションの数を3つ定義すれば3音源2マイク等も出力可能（音源数も同じ数に設定すること）
micNum(1) = "21";
micNum(2) = "23"; % マイクの数を3つ定義すれば2音源3マイク等も出力可能
impFs = 48000; % インパルス応答のサンプリング周波数 [Hz]（RWCPは常に48000Hz）

% impName = "JR2";
% srcPos(1) = "060";
% srcPos(2) = "120";
% micNum(1) = "21";
% micNum(2) = "23";
% impFs = 48000; % インパルス応答のサンプリング周波数 [Hz]（RWCPは常に48000Hz）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 音源の設定 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%srcDirName = "dev1__bearlin-roads__tracks";
%srcName(1) = "dev1__bearlin-roads__snip_85_99__drums.wav";
%srcName(2) = "dev1__bearlin-roads__snip_85_99__vocals.wav";
%srcFs = 44100; % 音源のサンプリング周波数 [Hz]（SiSECのMUSは常に41000Hz）

% srcDirName = "dev2__another_dreamer-the_ones_we_love__tracks";
% srcName(1) = "dev2__another_dreamer-the_ones_we_love__snip_69_94__drums.wav";
% srcName(2) = "dev2__another_dreamer-the_ones_we_love__snip_69_94__vocals.wav";
% srcFs = 44100; % 音源のサンプリング周波数 [Hz]（SiSECのMUSは常に41000Hz）

% srcDirName = "dev2__fort_minor-remember_the_name__tracks";
% srcName(1) = "dev2__fort_minor-remember_the_name__snip_54_78__drums.wav";
% srcName(2) = "dev2__fort_minor-remember_the_name__snip_54_78__vocals.wav";
% srcFs = 44100; % 音源のサンプリング周波数 [Hz]（SiSECのMUSは常に41000Hz）

% srcDirName = "dev2__ultimate_nz_tour__tracks";
% srcName(1) = "dev2__ultimate_nz_tour__snip_43_61__drums.wav";
% srcName(2) = "dev2__ultimate_nz_tour__snip_43_61__vocals.wav";
% srcFs = 44100; % 音源のサンプリング周波数 [Hz]（SiSECのMUSは常に41000Hz）

% srcDirName = "dev1_female4_src_12";
% srcName(1) = "dev1_female4_src_1.wav";
% srcName(2) = "dev1_female4_src_2.wav";
% srcFs = 16000; % 音源のサンプリング周波数 [Hz]（SiSECのUNDは常に16000Hz）

% srcDirName = "dev1_female4_src_34";
% srcName(1) = "dev1_female4_src_3.wav";
% srcName(2) = "dev1_female4_src_4.wav";
% srcFs = 16000; % 音源のサンプリング周波数 [Hz]（SiSECのUNDは常に16000Hz）

% srcDirName = "dev1_male4_src_12";
% srcName(1) = "dev1_male4_src_1.wav";
% srcName(2) = "dev1_male4_src_2.wav";
% srcFs = 16000; % 音源のサンプリング周波数 [Hz]（SiSECのUNDは常に16000Hz）

% srcDirName = "dev1_male4_src_34";
% srcName(1) = "dev1_male4_src_3.wav";
% srcName(2) = "dev1_male4_src_4.wav";
% srcFs = 16000; % 音源のサンプリング周波数 [Hz]（SiSECのUNDは常に16000Hz）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for k = 1:200
     srcDirName = "10s_wav";
     s1 = randi([1 49],1,1);
     s2 = randi([50 99],1,1);
     srcName(1) = string(s1)+".wav";
     srcName(2) = string(s2)+".wav";
     srcFs = 16000; % 音源のサンプリング周波数 [Hz]（SiSECのUNDは常に16000Hz）
    % Load impulse response files
    nPos = size(srcPos,2); % インパルス応答数
    nMic = size(micNum,2); % 観測マイク数
    for pos = 1:nPos
        for mic = 1:nMic
            fileName(pos,mic) = sprintf("./ImpulseResponse_RWCP_%s/imp%s.%s", impName, srcPos(pos), micNum(mic)); % 読み込むインパルス応答のファイル名
            fileID(pos,mic) = fopen(fileName(pos,mic)); % ファイルオープン
            imp(:,pos,mic) = fread(fileID(pos,mic), inf, 'float'); % raw形式のインパルス応答を単精度で読み込み（サイズinfは各要素に値が入った列ベクトルとしての読み込みを指定）
            imp_resample(:,pos,mic) = resample(imp(:,pos,mic),srcFs,impFs,100); % インパルス応答と音源のサンプリング周波数を合わせるために，インパルス応答をダウンサンプリング（sinc関数の次数を100とする）
        end
    end

    % Load audio source files
    nSong = size(srcName,2); % 音源数
    if nSong ~= nPos
        error('ポジション数と音源数は一致しなければなりません');
    end
    for src = 1:nSong
        sigName(src) = sprintf("./Dataset/%s/%s",srcDirName,srcName(src));
        [tmp, fs] = audioread(sigName(src));
        tmp = resample(tmp,16000,24000);

        %if fs ~= srcFs8
            %error('音源のサンプリング周波数の設定が間違っています');
        %end
        sig(:,src) = tmp(:,1); % モノラル化（左チャネルの音だけを仕様）
    end

    % Convolution
    for pos = 1:nPos
        for mic = 1:nMic
            sig_conv(:,mic,pos) = conv(imp_resample(:,pos,mic),sig(:,pos)); % sig_convは sigLength x mic x pos に並び替えられている点に注意（保存時のため）
        end
    end

    % Output
    OutputDir = sprintf('./output/%dsrc_%dmic/%s_%s_conv/%d', nSong, nMic, srcDirName, impName,k);
    if ~isdir( OutputDir )
        mkdir( OutputDir ); % フォルダが無ければ新規作成
    end
    for src = 1:nSong
        outputName = sprintf('%s/%s_%s_pos%s_mic%s%s_conv.wav', OutputDir, strrep(srcName(src), '.wav', ''), impName, srcPos(src), micNum(1), micNum(2));
        audiowrite(outputName, sig_conv(:,:,src), srcFs); % 多チャネルのWavファイルとして書き込み（3チャネル以上も対応）
    end
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%