import 'package:leancloud_storage/leancloud.dart';

Future initNorthChina() async {
  await LeanCloud.initialize('ikGGdRE2YcVOemAaRbgp1xGJ-gzGzoHsz', 'NUKmuRbdAhg1vrb2wexYo1jo', server: 'https://ikggdre2.lc-cn-n1-shared.com');
}

Future initUS() async {
  await LeanCloud.initialize('UlCpyvLm8aMzQsW6KnP6W3Wt-MdYXbMMI', 'PyCTYoNoxCVoKKg394PBeS4r', server: 'https://ulcpyvlm.api.lncldglobal.com');
}