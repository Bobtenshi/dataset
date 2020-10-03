% RWCP�C���p���X�������g������ݍ��݃X�N���v�g

clear;
close all;

%%%%%%%%%%%%%%%%%%%%%%%% �C���p���X�����̐ݒ� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
impName = "JR2";
srcPos(1) = "060";
srcPos(2) = "120"; % �|�W�V�����̐���3��`�����3����2�}�C�N�����o�͉\�i���������������ɐݒ肷�邱�Ɓj
micNum(1) = "21";
micNum(2) = "23"; % �}�C�N�̐���3��`�����2����3�}�C�N�����o�͉\
impFs = 48000; % �C���p���X�����̃T���v�����O���g�� [Hz]�iRWCP�͏��48000Hz�j

% impName = "JR2";
% srcPos(1) = "060";
% srcPos(2) = "120";
% micNum(1) = "21";
% micNum(2) = "23";
% impFs = 48000; % �C���p���X�����̃T���v�����O���g�� [Hz]�iRWCP�͏��48000Hz�j
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �����̐ݒ� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%srcDirName = "dev1__bearlin-roads__tracks";
%srcName(1) = "dev1__bearlin-roads__snip_85_99__drums.wav";
%srcName(2) = "dev1__bearlin-roads__snip_85_99__vocals.wav";
%srcFs = 44100; % �����̃T���v�����O���g�� [Hz]�iSiSEC��MUS�͏��41000Hz�j

% srcDirName = "dev2__another_dreamer-the_ones_we_love__tracks";
% srcName(1) = "dev2__another_dreamer-the_ones_we_love__snip_69_94__drums.wav";
% srcName(2) = "dev2__another_dreamer-the_ones_we_love__snip_69_94__vocals.wav";
% srcFs = 44100; % �����̃T���v�����O���g�� [Hz]�iSiSEC��MUS�͏��41000Hz�j

% srcDirName = "dev2__fort_minor-remember_the_name__tracks";
% srcName(1) = "dev2__fort_minor-remember_the_name__snip_54_78__drums.wav";
% srcName(2) = "dev2__fort_minor-remember_the_name__snip_54_78__vocals.wav";
% srcFs = 44100; % �����̃T���v�����O���g�� [Hz]�iSiSEC��MUS�͏��41000Hz�j

% srcDirName = "dev2__ultimate_nz_tour__tracks";
% srcName(1) = "dev2__ultimate_nz_tour__snip_43_61__drums.wav";
% srcName(2) = "dev2__ultimate_nz_tour__snip_43_61__vocals.wav";
% srcFs = 44100; % �����̃T���v�����O���g�� [Hz]�iSiSEC��MUS�͏��41000Hz�j

% srcDirName = "dev1_female4_src_12";
% srcName(1) = "dev1_female4_src_1.wav";
% srcName(2) = "dev1_female4_src_2.wav";
% srcFs = 16000; % �����̃T���v�����O���g�� [Hz]�iSiSEC��UND�͏��16000Hz�j

% srcDirName = "dev1_female4_src_34";
% srcName(1) = "dev1_female4_src_3.wav";
% srcName(2) = "dev1_female4_src_4.wav";
% srcFs = 16000; % �����̃T���v�����O���g�� [Hz]�iSiSEC��UND�͏��16000Hz�j

% srcDirName = "dev1_male4_src_12";
% srcName(1) = "dev1_male4_src_1.wav";
% srcName(2) = "dev1_male4_src_2.wav";
% srcFs = 16000; % �����̃T���v�����O���g�� [Hz]�iSiSEC��UND�͏��16000Hz�j

% srcDirName = "dev1_male4_src_34";
% srcName(1) = "dev1_male4_src_3.wav";
% srcName(2) = "dev1_male4_src_4.wav";
% srcFs = 16000; % �����̃T���v�����O���g�� [Hz]�iSiSEC��UND�͏��16000Hz�j
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for k = 1:200
     srcDirName = "10s_wav";
     s1 = randi([1 49],1,1);
     s2 = randi([50 99],1,1);
     srcName(1) = string(s1)+".wav";
     srcName(2) = string(s2)+".wav";
     srcFs = 16000; % �����̃T���v�����O���g�� [Hz]�iSiSEC��UND�͏��16000Hz�j
    % Load impulse response files
    nPos = size(srcPos,2); % �C���p���X������
    nMic = size(micNum,2); % �ϑ��}�C�N��
    for pos = 1:nPos
        for mic = 1:nMic
            fileName(pos,mic) = sprintf("./ImpulseResponse_RWCP_%s/imp%s.%s", impName, srcPos(pos), micNum(mic)); % �ǂݍ��ރC���p���X�����̃t�@�C����
            fileID(pos,mic) = fopen(fileName(pos,mic)); % �t�@�C���I�[�v��
            imp(:,pos,mic) = fread(fileID(pos,mic), inf, 'float'); % raw�`���̃C���p���X������P���x�œǂݍ��݁i�T�C�Yinf�͊e�v�f�ɒl����������x�N�g���Ƃ��Ă̓ǂݍ��݂��w��j
            imp_resample(:,pos,mic) = resample(imp(:,pos,mic),srcFs,impFs,100); % �C���p���X�����Ɖ����̃T���v�����O���g�������킹�邽�߂ɁC�C���p���X�������_�E���T���v�����O�isinc�֐��̎�����100�Ƃ���j
        end
    end

    % Load audio source files
    nSong = size(srcName,2); % ������
    if nSong ~= nPos
        error('�|�W�V�������Ɖ������͈�v���Ȃ���΂Ȃ�܂���');
    end
    for src = 1:nSong
        sigName(src) = sprintf("./Dataset/%s/%s",srcDirName,srcName(src));
        [tmp, fs] = audioread(sigName(src));
        tmp = resample(tmp,16000,24000);

        %if fs ~= srcFs8
            %error('�����̃T���v�����O���g���̐ݒ肪�Ԉ���Ă��܂�');
        %end
        sig(:,src) = tmp(:,1); % ���m�������i���`���l���̉��������d�l�j
    end

    % Convolution
    for pos = 1:nPos
        for mic = 1:nMic
            sig_conv(:,mic,pos) = conv(imp_resample(:,pos,mic),sig(:,pos)); % sig_conv�� sigLength x mic x pos �ɕ��ёւ����Ă���_�ɒ��Ӂi�ۑ����̂��߁j
        end
    end

    % Output
    OutputDir = sprintf('./output/%dsrc_%dmic/%s_%s_conv/%d', nSong, nMic, srcDirName, impName,k);
    if ~isdir( OutputDir )
        mkdir( OutputDir ); % �t�H���_��������ΐV�K�쐬
    end
    for src = 1:nSong
        outputName = sprintf('%s/%s_%s_pos%s_mic%s%s_conv.wav', OutputDir, strrep(srcName(src), '.wav', ''), impName, srcPos(src), micNum(1), micNum(2));
        audiowrite(outputName, sig_conv(:,:,src), srcFs); % ���`���l����Wav�t�@�C���Ƃ��ď������݁i3�`���l���ȏ���Ή��j
    end
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EOF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%