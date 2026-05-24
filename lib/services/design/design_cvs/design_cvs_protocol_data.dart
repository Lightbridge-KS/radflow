// ===== DATA MODULE for Design CTA & MRA for Cardiovascular Study =====

class DesignCvsProtocolData {
  // ID-based hierarchical mapping from: `exam_id` -> `protocol_id` (2 level dependent dropdown)
  // These will appear in the app dropdown level 1 and 2 respectively. 
  static const Map<String, List<String>> choiceIdMap = {
    "ct": [
      "ct_calcium",
      "cta_coro",
      "cta_cardiac_mass",
      "cta_aortic_dissect",
      "cta_ruptured_aortic_aneu",
      "cta_pe",
      "cta_tavr_preop",
      "cta_tevar_evar_follow"
    ],
    "mri": [
      "mra_tra_ste_trv_thrombo"
    ]
  };

  // ID to Display name mapping (what users see in the dropdown)
  static const Map<String, String> idDispMap = {
    // Exam: `exam_id` -> `exam_name`
    "ct": "CT",
    "mri": "MRI",
    // Protocol: `protocol_id` -> `protocol_name`
    "ct_calcium": "CT Screening Coronary (CAC)",
    "cta_coro": "CTA Coronary (CAD)",
    "cta_cardiac_mass": "CTA Cardiac Mass",
    "cta_aortic_dissect": "CTA Aortic Dissection",
    "cta_ruptured_aortic_aneu": "CTA Rupture Aortic Aneurysm",
    "cta_pe": "CTA for PE",
    "cta_tavr_preop": "CTA Whole Aorta (pre-op TAVR)",
    "cta_tevar_evar_follow": "CTA Whole Aorta (TEVAR/EVAR)",
    "mra_tra_ste_trv_thrombo": "MRA for TRA Stenosis / TRV Thrombosis"
  };

  // Protocol Information
  static final Map<String, Map<String, Object?>> protocolInfo = {
    // CT Screening Coronary (CAC)
    "ct_calcium": {
      'protocolName': idDispMap['ct_calcium']!,
      'contrastText': "non-contrast",
      'phaseDesignText': '''
- Prospective ECG-gated CT covers the heart
''',
      'note': null
    },
    // CTA Coronary (CAD)
    "cta_coro": {
      'protocolName': idDispMap['cta_coro']!,
      'contrastText': 'IV contrast 50-100 ml at right antecubital fossa, flow rate 5 ml/sec',
      'phaseDesignText': '''
- Coronary artery calcium scoring
- ECG-gated CTA covers the heart
- Venous (chest)
''',
      'note': '''
Patient with CABG -> scan cover from the **thoracic inlet to the base of heart**
'''
    },
    // CTA Cardiac Mass
    "cta_cardiac_mass": {
      'protocolName': idDispMap['cta_cardiac_mass']!,
      'contrastText': 'IV contrast 60-100 ml at right antecubital fossa, flow rate 5 ml/sec',
      'phaseDesignText': '''
- Pre-contrast: prospective ECG-gated CT covers the heart
- ECG-gated CTA covers the heart
- Delayed or venous phase (chest and cardiac mass)
''',
      'note': null
    },
    // CTA Aortic Dissection
    "cta_aortic_dissect": {
      'protocolName': idDispMap['cta_aortic_dissect']!,
      'contrastText': 'IV contrast 70-100 ml at right antecubital fossa, flow rate 5 ml/sec',
      'phaseDesignText': '''
- Pre-contrast (whole aorta)
- CTA (whole aorta)
- Venous (chest and whole abdomen)
''',
      'note': '''
In a patient with suspected Stanford type A aortic dissection, ECG-gated CTA of the ascending thoracic aorta is recommended, followed by CTA of the abdominal aorta.
'''
    },
    // CTA Rupture Aortic Aneurysm
    "cta_ruptured_aortic_aneu": {
      'protocolName': idDispMap['cta_ruptured_aortic_aneu']!,
      'contrastText': 'IV contrast 70-100 ml at right antecubital fossa, flow rate 5 ml/sec',
      'phaseDesignText': '''
- Pre-contrast (whole aorta)
- CTA (whole aorta)
- Venous (chest and whole abdomen)
''',
      'note': null
    },
    // CTA for PE
    "cta_pe": {
      'protocolName': idDispMap['cta_pe']!,
      'contrastText': 'IV contrast 60-100 ml at right antecubital fossa, flow rate 5 ml/sec',
      'phaseDesignText': '''
- Pre-contrast (chest)
- CTPA (pulmonary artery)
- Venous (chest)
''',
      'note': null
    },
    // CTA Whole Aorta (pre-op TAVR)
    "cta_tavr_preop": {
      'protocolName': idDispMap['cta_tavr_preop']!,
      'contrastText': 'IV contrast 70-100 ml at right antecubital fossa, flow rate 5 ml/sec',
      'phaseDesignText': '''
- Pre-contrast: prospective ECG-gated CT covers the heart to evaluate aortic valve calcium scoring
- ECG-gated CTA covers the ascending aorta to the base of the heart
- Immediate delay (whole aorta)
''',
      'note': null
    },
    // CTA Whole Aorta (TEVAR/EVAR)
    "cta_tevar_evar_follow": {
      'protocolName': idDispMap['cta_tevar_evar_follow']!,
      'contrastText': 'IV contrast 70-100 ml at right antecubital fossa, flow rate 5 ml/sec',
      'phaseDesignText': '''
- Pre-contrast (whole aorta)
- CTA (whole aorta)
- Venous (whole aorta)
-  Delayed phase 80-120 sec (covers **Only the stent**)
''',
      'note': null
    },
    // MRA for TRA Stenosis / TRV Thrombosis
    "mra_tra_ste_trv_thrombo": {
      'protocolName': idDispMap['mra_tra_ste_trv_thrombo']!,
      'contrastText': 'IV Gd-based contrast, dose 0.1-0.2 mmol/kg, flow rate 1.5-2.5 ml/sec',
      'phaseDesignText': '''
- Ax T1W DIXON (In-phase, oppose phase, fat only, water only)
- Ax T2W Fast Spin Echo Fat Saturated
- B-TRANCE
- Cor contrast-enhanced MRA and MRV
- Ax and Cor contrast-enhanced T1 fat-sat
''',
      'note': null
    }
  };
}