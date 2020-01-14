import 'package:leancloud_storage/leancloud.dart';

void initNorthChina() {
  LeanCloud.initialize('ikGGdRE2YcVOemAaRbgp1xGJ-gzGzoHsz', 'NUKmuRbdAhg1vrb2wexYo1jo', server: 'https://ikggdre2.lc-cn-n1-shared.com');
  LCLogger.setLevel(LCLogger.DebugLevel);
}

void initUS() {
  LeanCloud.initialize('UlCpyvLm8aMzQsW6KnP6W3Wt-MdYXbMMI', 'PyCTYoNoxCVoKKg394PBeS4r');
  LCLogger.setLevel(LCLogger.DebugLevel);
}