// ===== DATA MODULE =====

class ProtocolData {
  // ID-based hierarchical mapping from: `category_id` -> `exam_id` -> `protocol_id`
  // These will appear in the app dropdown level 1, 2, and 3, respectively. 
  static const Map<String, Map<String, List<String>>> choiceIdMap = {
    'body': {
      'ct_whole_abd': [
        'ct_whole_abd_routine',
        'ct_whole_abd_full',
        'ct_whole_abd_gut_obs',
        'ct_whole_abd_infect',
        'ct_whole_abd_leak_fist_collect',
        'ct_whole_abd_diver',
        'ct_whole_abd_pancrea',
        'ct_whole_abd_free_air',
        'ct_whole_abd_solid_rupture',
        'ct_whole_abd_gi_perforate',
        'ct_whole_abd_hbp_mass',
        'ct_whole_abd_kidney_mass',
        'ct_whole_abd_gi_mass',
      ],
      'cta_whole_abd': [
        'cta_whole_abd_mesenteric_ischemia',
        'cta_whole_abd_gi_bleed',
        'cta_whole_abd_aaa_rupture',
      ],
      'ct_upper_abd': [
        'ct_upper_abd_routine',
        'ct_upper_abd_biliary_stone',
        'ct_upper_abd_hbp_mass',
        'ct_upper_abd_adrenal_mass',
      ],
      'ct_lower_abd': ['ct_lower_abd_appendix'],
      'ct_kub': [
        'ct_kub_nc',
        'ct_kub_stone',
        'ct_kub_hematuria',
        'ct_kub_kidney_mass',
      ],
      'cta_pe': ['cta_pe_no_dvt', 'cta_pe_with_dvt'],
      'ct_chest': [
        'ct_chest_routine',
        'ct_chest_nc',
        'ct_chest_nodule_mass',
        'ct_chest_tbm',
        'ct_chest_dysphagia',
        'ct_chest_eso',
        'ct_chest_svc',
      ],
      'ct_chest_whole_abd': ['ct_chest_whole_abd_full'],
      'cta_chest': ['cta_chest_hemoptysis', 'cta_chest_trauma'],
      'cta_aorta': [
        'cta_aorta_first',
        'cta_aorta_dissect',
        'cta_aorta_aaa_postop',
      ],
      'cta_runoff': ['cta_runoff_old', 'cta_runoff_young'],
    },
    'neuro': {
      'ct_brain_nc': ['ct_brain_nc_routine'],
      'ct_brain_with_cm': ['ct_brain_with_cm_routine'],
      'cta_ctv_brain': ['cta_brain_aneurysm', 'ctv_brain_vst'],
      'mri_spine': ['mri_screening_whole_spine'],
    },
    'trauma': {
      'ct_neuro_trauma': [
        'cta_neck_trauma',
        'ct_facial_trauma',
        'ct_orbit_trauma',
      ],
      'ct_body_trauma': [
        'pan_scan',
        'cta_blunt_abd',
        'cta_penetrate_abd',
        'ct_second_look_abd',
        'cta_chest_trauma',
      ],
    },
  };

  // ID to Display name mapping (what users see in the dropdown)
  static const Map<String, String> idDispMap = {
    // Category: `category_id` -> `category_name`
    'body': 'Body',
    'neuro': 'Neuro',
    'trauma': 'Trauma',
    // Exam: `exam_id` -> `exam_name`
    'ct_whole_abd': 'CTWA',
    'cta_whole_abd': 'CTA Whole Abd',
    'ct_upper_abd': 'CT Upper Abd',
    'ct_lower_abd': 'CT Lower Abd',
    'ct_kub': 'CT KUB',
    'cta_pe': 'CTA for PE',
    'ct_chest': 'CT Chest',
    'ct_chest_whole_abd': 'CT Chest + Whole Abd',
    'cta_chest': 'CTA Chest',
    'cta_aorta': 'CTA Whole Aorta',
    'cta_runoff': 'CTA runoff',
    'ct_brain_nc': 'CT Brain (non-contrast)',
    'ct_brain_with_cm': 'CT Brain with Contrast',
    'cta_ctv_brain': 'CTA/CTV Brain',
    'mri_spine': 'MRI Spine',
    'ct_neuro_trauma': 'CT Neuro Trauma',
    'ct_body_trauma': 'CT Body Trauma',
    // Protocol: `protocol_id` -> `protocol_name`
    'ct_whole_abd_routine': 'Routine WA',
    'ct_whole_abd_full': 'Full WA',
    'ct_whole_abd_gut_obs': 'Gut Obstruction',
    'ct_whole_abd_infect': 'Intra-abdominal infection',
    'ct_whole_abd_leak_fist_collect': 'Leak-Fistula-Collection',
    'ct_whole_abd_diver': 'Diverticulitis',
    'ct_whole_abd_pancrea': 'Pancreatitis',
    'ct_whole_abd_free_air': 'Free Air',
    'ct_whole_abd_solid_rupture': 'Solid Organ Rupture',
    'ct_whole_abd_gi_perforate': 'GI Perforation',
    'ct_whole_abd_hbp_mass': 'HBP mass/abscess (CTWA)',
    'ct_whole_abd_kidney_mass': 'Kidney mass/abscess',
    'ct_whole_abd_gi_mass': 'GI Mass',
    'ct_upper_abd_routine': 'Routine Upper Abd',
    'ct_upper_abd_biliary_stone': 'Biliary Stone',
    'ct_upper_abd_hbp_mass': 'HBP mass/abscess (Upper)',
    'ct_upper_abd_adrenal_mass': 'Adrenal mass/abscess',
    'ct_lower_abd_appendix': 'Appendicitis',
    'ct_kub_nc': 'CT KUB (non-contrast)',
    'ct_kub_stone': 'KUB Stone',
    'ct_kub_hematuria': 'Hematuria',
    'ct_kub_kidney_mass': 'Kidney mass/Abscess',
    'cta_whole_abd_gi_bleed': 'GI Bleed',
    'cta_whole_abd_mesenteric_ischemia': 'Mesenteric Ischemia',
    'cta_whole_abd_aaa_rupture': 'AAA Rupture',
    'cta_pe_no_dvt': 'CTA for PE (ไม่ลากขา)',
    'cta_pe_with_dvt': 'CTA for PE with DVT',
    'ct_chest_routine': 'Routine CT Chest',
    'ct_chest_nc': 'CT Chest (non-contrast)',
    'ct_chest_nodule_mass': 'Nodule/mass characterization',
    'ct_chest_tbm': 'Tracheobronchomalacia',
    'ct_chest_dysphagia': 'Dysphagia',
    'ct_chest_eso': 'CT esophagogram',
    'ct_chest_svc': 'SVC Obstruction',
    'ct_chest_whole_abd_full': 'Full CT Chest + WA',
    'cta_chest_hemoptysis': 'Hemoptysis',
    'cta_chest_trauma': 'CTA Chest trauma',
    'cta_aorta_first': 'Aorta first time',
    'cta_aorta_dissect': 'Aortic Dissection',
    'cta_aorta_aaa_postop': 'AAA Post-op',
    'cta_runoff_old': 'CTA Runoff',
    'cta_runoff_young': 'CTA Runoff (< 60 yr)',
    'ct_brain_nc_routine': 'CT Brain (non-contrast)',
    'cta_brain_aneurysm': 'Intracranial aneurysm',
    'ctv_brain_vst': 'Venous Sinus Thrombosis',
    'ct_brain_with_cm_routine': 'CT Brain with Contrast',
    'cta_neck_trauma': 'CTA Neck (trauma)',
    'ct_facial_trauma': 'CT Facial Bone (trauma)',
    'ct_orbit_trauma': 'CT Orbit (trauma)',
    'pan_scan': 'Pan-Scan Whole body CT (trauma)',
    'cta_blunt_abd': 'CTA Blunt Abdomen (trauma)',
    'cta_penetrate_abd': 'CTA Penetrating Abd (trauma)',
    'ct_second_look_abd': 'CT Second look Abd (trauma)',
    'mri_screening_whole_spine': 'MRI Screening Whole Spine',
  };
  // Protocol Information
  static final Map<String, Map<String, Map<String, Object>>> protocolInfo = {
    'ct': {
      /* 
      ==== CTWA ==== 
      */
      // Routine WA
      'ct_whole_abd_routine': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_routine']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Venous (whole)
- Delay (liver)
''',
        'contrastText': 'Oral (limited water), Rectal (water)',
      },
      // Full WA
      'ct_whole_abd_full': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': false,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (whole)
- Late A (upper)
- Venous (whole)
- Delay (liver)
''',
        'contrastText': 'Oral (?), Rectal (?)',
      },
      // Solid Organ Rupture
      'ct_whole_abd_solid_rupture': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_solid_rupture']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (whole)
- Late A (upper)
- Venous (whole)
- Delay (upper)
''',
        'contrastText': 'No oral, No rectal',
      },
      // Free Air
      'ct_whole_abd_free_air': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_free_air']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain
- Venous (may be)
''',
        'contrastText': 'Oral (positive), Rectal (positive) [If not stable -> no oral, no rectal]',
      },
      // GI Perforate
      'ct_whole_abd_gi_perforate': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_gi_perforate']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Venous
- Delay (liver)
''',
        'contrastText': 'Oral (limited positive), Rectal (positive)',
      },
      // Gut Obstruction
      'ct_whole_abd_gut_obs': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_gut_obs']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Venous (whole)
- Delay 3 min (liver)
''',
        'contrastText': 'No oral, No rectal',
      },
      // HBP mass/abscess (CTWA)
      'ct_whole_abd_hbp_mass': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_hbp_mass']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (upper)
- Late A (upper)
- Venous (whole)
- Delay (upper)
''',
        'contrastText': 'Oral (limited water), No rectal',
      },
      // Kidney mass/abscess
      'ct_whole_abd_kidney_mass': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_kidney_mass']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (KUB)
- Late A (upper)
- Venous (100 sec)
- Delay (KUB)
''',
        'contrastText': 'Oral (limited water), No rectal',
      },
      // GI Mass
      'ct_whole_abd_gi_mass': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_gi_mass']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Venous (whole)
- Delay (liver)
''',
        'contrastText': 'Oral (full positive), Rectal (water)',
      },
      // Diverticulitis
      'ct_whole_abd_diver': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_diver']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Venous (whole)
- Delay (liver)
''',
        'contrastText': 'Oral (limited water), Rectal (1 L, positive CM)',
      },
      // Pancreatitis
      'ct_whole_abd_pancrea': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_pancrea']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (upper)
- Late A (upper)
- Venous (whole)
- Delay (upper)
''',
        'contrastText': 'Oral (limited water), No rectal',
      },
      // Intra-abdominal infection
      'ct_whole_abd_infect': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_infect']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (whole)
- Late A (upper)
- Venous (whole)
- Delay (upper)
''',
        'contrastText': 'Oral (limited water), Rectal (water)',
      },
      // Leak-Fistula-Collection
      'ct_whole_abd_leak_fist_collect': {
        'examName': idDispMap['ct_whole_abd']!,
        'protocolName': idDispMap['ct_whole_abd_leak_fist_collect']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Venous (whole)
- Delay (liver)
''',
        'contrastText': 'Oral (if Hx bowel resect -> full positive; If not -> limited positive), Rectal (positive) ?',
      },
      /* 
      ==== CT Upper Abd ==== 
      */
      // Routine Upper Abd
      'ct_upper_abd_routine': {
        'examName': idDispMap['ct_upper_abd']!,
        'protocolName': idDispMap['ct_upper_abd_routine']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Venous (upper)
- Delay (upper)
''',
        'contrastText': 'Oral (limited water), No rectal',
      },
      // HBP mass/abscess (Upper)
      'ct_upper_abd_hbp_mass': {
        'examName': idDispMap['ct_upper_abd']!,
        'protocolName': idDispMap['ct_upper_abd_hbp_mass']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (upper)
- Late A (upper)
- Venous (upper)
- Delay (upper)
''',
        'contrastText': 'Oral (limited water), No rectal',
      },
      // Biliary Stone
      'ct_upper_abd_biliary_stone': {
        'examName': idDispMap['ct_upper_abd']!,
        'protocolName': idDispMap['ct_upper_abd_biliary_stone']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (upper)
- Late A (upper)
- Venous (upper)
- Delay (liver)
''',
        'contrastText': 'Oral (limited water), No rectal',
      },
      // Adrenal mass/abscess
      'ct_upper_abd_adrenal_mass': {
        'examName': idDispMap['ct_upper_abd']!,
        'protocolName': idDispMap['ct_upper_abd_adrenal_mass']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (upper)
- Late A (upper)
- Venous (upper)
- Delay 3 min (upper)
*** Check ภาพ +/- Delay 15 min (adrenal)
''',
        'contrastText': 'Oral (limited water), No rectal',
      },
      /* 
      ==== CT Lower Abd ==== 
      */
      'ct_lower_abd_appendix': {
        'examName': idDispMap['ct_lower_abd']!,
        'protocolName': idDispMap['ct_lower_abd_appendix']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Venous 120 sec (L3 to pubic symphysis)
''',
        'contrastText': 'Rectal (Positive 1 L สวนถึง cecum), No oral',
      },
      /* 
      ==== CT KUB ==== 
      */
      // CT KUB (non-contrast)
      'ct_kub_nc': {
        'examName': 'CT KUB (non-contrast)',
        'protocolName': false,
        'useIVcontrast': false,
        'phaseDesignText': '''
- Plain KUB (kidneys to pubic symphysis)
*** Check ภาพก่อนเลิก
''',
        'contrastText': 'No Oral, No Rectal',
      },
      // KUB Stone
      'ct_kub_stone': {
        'examName': 'CT KUB (non-contrast)',
        'protocolName': idDispMap['ct_kub_stone']!,
        'useIVcontrast': false,
        'phaseDesignText': '''
- Plain KUB (kidneys to pubic symphysis)
*** Check ภาพก่อนเลิก
''',
        'contrastText': 'No Oral, No Rectal',
      },
      // Hematuria
      'ct_kub_hematuria': {
        'examName': idDispMap['ct_kub']!,
        'protocolName': idDispMap['ct_kub_hematuria']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (KUB)
- Late A (Kidney)
- Venous (KUB)
- Delay (KUB)
*** Check ภาพก่อนเลิก
''',
        'contrastText': 'Oral (limited water), No Rectal',
      },
      // Kidney mass/Abscess
      'ct_kub_kidney_mass': {
        'examName': idDispMap['ct_kub']!,
        'protocolName': idDispMap['ct_kub_kidney_mass']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
*** If suspect renal mass → consider CTWA for staging
- Plain (KUB)
- Late A (Upper)
- Venous (100 sec)
- Delay (KUB)
*** Check ภาพก่อนเลิก
''',
        'contrastText': 'Oral (limited water), No Rectal',
      },
      /* 
      ==== CTA Whole Abd ==== 
      */
      // GI Bleed
      'cta_whole_abd_gi_bleed': {
        'examName': idDispMap['cta_whole_abd']!,
        'protocolName': idDispMap['cta_whole_abd_gi_bleed']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (whole)
- CTA (whole)
- Venous (whole)
- Delay (whole)
''',
        'contrastText': 'No oral, No rectal',
      },
      // Mesenteric Ischemia
      'cta_whole_abd_mesenteric_ischemia': {
        'examName': idDispMap['cta_whole_abd']!,
        'protocolName': idDispMap['cta_whole_abd_mesenteric_ischemia']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (whole)
- CTA (whole)
- Venous (whole)
- Delay (whole)
''',
        'contrastText': 'Oral (limited water), Rectal (water)',
      },
      // AAA Rupture
      'cta_whole_abd_aaa_rupture': {
        'examName': idDispMap['cta_whole_abd']!,
        'protocolName': idDispMap['cta_whole_abd_aaa_rupture']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (whole)
- CTA (maybe ถ้ามีเวลา คนไข้ stable)
- Venous (maybe ถ้ามีเวลา คนไข้ stable)
''',
        'contrastText': 'No oral, No rectal',
      },
      /* 
      ==== CTA for PE ==== 
      */
      'cta_pe_no_dvt': {
        'examName': idDispMap['cta_pe']!,
        'protocolName': idDispMap['cta_pe_no_dvt']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- CTPA (chest)
- Venous (chest)
''',
        'contrastText': 'IV contrast',
      },
      'cta_pe_with_dvt': {
        'examName': idDispMap['cta_pe']!,
        'protocolName': idDispMap['cta_pe_with_dvt']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- CTPA (chest)
- Venous (chest, legs)
''',
        'contrastText': 'IV contrast',
      },
      /* 
      ==== CT Chest ==== 
      */
      // Routine Chest
      'ct_chest_routine': {
        'examName': idDispMap['ct_chest']!,
        'protocolName': idDispMap['ct_chest_routine']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- **maybe** plain (chest)
- Late A (chest)
''',
        'contrastText': 'IV contrast',
      },
      // CT Chest (non-contrast)
      'ct_chest_nc': {
        'examName': 'CT Chest (non-contrast)',
        'protocolName': false,
        'useIVcontrast': false,
        'phaseDesignText': '''
- plain (chest)
''',
        'contrastText': 'No IV contrast',
      },
      // Nodule/mass characterization
      'ct_chest_nodule_mass': {
        'examName': idDispMap['ct_chest']!,
        'protocolName': idDispMap['ct_chest_nodule_mass']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (chest)
- Late A (chest)
''',
        'contrastText': 'IV contrast',
      },
      // Tracheobronchomalacia
      'ct_chest_tbm': {
        'examName': idDispMap['ct_chest']!,
        'protocolName': idDispMap['ct_chest_tbm']!,
        'useIVcontrast': false,
        'phaseDesignText': '''
- Plain (chest, dynamic expiration)
''',
        'contrastText': 'No IV contrast',
      },
      // Dysphagia
      'ct_chest_dysphagia': {
        'examName': idDispMap['ct_chest']!,
        'protocolName': idDispMap['ct_chest_dysphagia']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (chest)
- Venous (chest)
''',
        'contrastText': 'IV contrast, Oral (limited water)',
      },
      // CT esophagogram
      'ct_chest_eso': {
        'examName': idDispMap['ct_chest']!,
        'protocolName': idDispMap['ct_chest_eso']!,
        'useIVcontrast': false,
        'phaseDesignText': '''
- Plain (Chest, reduced dose) ก่อนกิน CM
- จากนั้น กิน CM 1 cup (250 ml) ที่เตียง
- Venous (Chest) หลังกิน CM
''',
        'contrastText': 'Oral (Positive CM)',
      },
      // SVC Obstruction
      'ct_chest_svc': {
        'examName': idDispMap['ct_chest']!,
        'protocolName': idDispMap['ct_chest_svc']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (Chest, reduced dose)
- Late A (Chest)
- Immediate delay (Chest)
''',
        'contrastText': 'IV contrast',
      },
      // CT Chest + WA
      'ct_chest_whole_abd_full': {
        'examName': idDispMap['ct_chest_whole_abd']!,
        'protocolName': false,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (Chest + Whole abd)
- Late A (Chest + Upper abd)
- Venous (Whole abd)
- Delay (liver)
''',
        'contrastText': 'Oral (?), Rectal (?)',
      },
      /* 
      ==== CTA Chest ==== 
      */
      // Hemoptysis
      'cta_chest_hemoptysis': {
        'examName': idDispMap['cta_chest']!,
        'protocolName': idDispMap['cta_chest_hemoptysis']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (Chest)
- CTA (Apex to L2) → Dual bolus
- Immediate delay (Chest)
* Note: L2 (Celiac Axis) ให้เห็น renal artery origin
''',
        'contrastText': 'IV contrast',
      },
      // CTA Chest trauma
      'cta_chest_trauma': {
        'examName': idDispMap['cta_chest']!,
        'protocolName': idDispMap['cta_chest_trauma']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- CTA (chest)
- Venous (chest)
''',
        'contrastText': 'IV Contrast',
      },
      /* 
      ==== CTA Aorta ==== 
      */
      // Aorta first time
      'cta_aorta_first': {
        'examName': idDispMap['cta_aorta']!,
        'protocolName': idDispMap['cta_aorta_first']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (whole aorta)
- CTA (whole aorta)
- Immediate delay (whole aorta)
''',
        'contrastText': 'IV contrast',
      },
      // Aortic Dissection
      'cta_aorta_dissect': {
        'examName': idDispMap['cta_aorta']!,
        'protocolName': idDispMap['cta_aorta_dissect']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (whole aorta)
- CTA (whole aorta)
- Immediate delay (whole aorta)
''',
        'contrastText': 'IV contrast',
      },
      // AAA Post-op
      'cta_aorta_aaa_postop': {
        'examName': idDispMap['cta_aorta']!,
        'protocolName': idDispMap['cta_aorta_aaa_postop']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (whole aorta)
- CTA (whole aorta)
- Immediate delay (whole aorta)
''',
        'contrastText': 'IV contrast',
      },
      /* 
      ==== CTA Runoff ==== 
      */
      'cta_runoff_old': {
        'examName': idDispMap['cta_runoff']!,
        'protocolName': idDispMap['cta_runoff_old']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
ขา → Aortic bifurcation to feet
แขน → mid-heart to hands
- Plain
- CTA
- Immediate delay
''',
        'contrastText': 'IV contrast',
      },
      'cta_runoff_young': {
        'examName': idDispMap['cta_runoff']!,
        'protocolName': idDispMap['cta_runoff_young']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
ขา → Aortic bifurcation to feet
แขน → mid-heart to hands
- CTA
- Immediate delay
''',
        'contrastText': 'IV contrast',
      },
      /* 
      ==== Neuro ==== 
      */
      // CT Brain
      'ct_brain_nc_routine': {
        'examName': idDispMap['ct_brain_nc']!,
        'protocolName': false,
        'useIVcontrast': false,
        'phaseDesignText': false,
        'contrastText': 'No IV contrast',
      },
      'ct_brain_with_cm_routine': {
        'examName': idDispMap['ct_brain_with_cm']!,
        'protocolName': false,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain, post-contrast (Brain)
''',
        'contrastText': 'IV contrast',
      },
      // CTA Brain
      'cta_brain_aneurysm': {
        'examName': 'CTA Brain',
        'protocolName': idDispMap['cta_brain_aneurysm']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain, CTA, post-contrast (Brain)
''',
        'contrastText': 'IV contrast',
      },
      'ctv_brain_vst': {
        'examName': 'CTV Brain',
        'protocolName': idDispMap['ctv_brain_vst']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain, CTV, post-contrast (Brain)
''',
        'contrastText': 'IV contrast',
      },
      /* 
      ==== Trauma ==== 
      */
      // CTA Neck (trauma)
      'cta_neck_trauma': {
        'examName': 'CTA Neck',
        'protocolName': idDispMap['cta_neck_trauma']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- CTA (brain, neck) COW to arch
- Post-contrast (brain)
''',
        'contrastText': 'IV contrast',
      },
      // CT facial bone (trauma)
      'ct_facial_trauma': {
        'examName': 'CT Facial Bone (non-contrast)',
        'protocolName': idDispMap['ct_facial_trauma']!,
        'useIVcontrast': false,
        'phaseDesignText': '''
- CT Facial Bones (plain) with 3D reformats
''',
        'contrastText': 'No IV contrast',
      },
      // CT Orbit (trauma)
      'ct_orbit_trauma': {
        'examName': 'CT Orbit (non-contrast)',
        'protocolName': idDispMap['ct_orbit_trauma']!,
        'useIVcontrast': false,
        'phaseDesignText': false,
        'contrastText': 'No IV contrast',
      },
      // Pan-Scan
      'pan_scan': {
        'examName': idDispMap['pan_scan']!,
        'protocolName': false,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Plain (Brain) [arms down]
- Arterial (COW → pubic symphysis) [arms up]
- Venous (Upper or Whole Abdomen)
- +/- delay kidney, ureter
- +/-  CT cystogram
''',
        'contrastText': 'IV contrast, No oral, No rectal',
      },
      // CTA Blunt Abdomen (trauma)
      'cta_blunt_abd': {
        'examName': idDispMap['cta_whole_abd']!,
        'protocolName': idDispMap['cta_blunt_abd']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- CTA (whole)
- Venous (whole)
- may be Delay (in injury site)
''',
        'contrastText': 'IV contrast, No oral, No rectal',
      },
      // CTA Penetrating Abd (trauma)
      'cta_penetrate_abd': {
        'examName': idDispMap['cta_whole_abd']!,
        'protocolName': idDispMap['cta_penetrate_abd']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- CTA (whole)
- Venous (whole)
- may be Delay (in injury site)
*** วาง marker ตําแหน่งแผลด้วย
''',
        'contrastText': 'IV contrast, Oral & Rectal full positive (ถ้ามีเวลา)',
      },
      // CT Second look Abd (trauma)
      'ct_second_look_abd': {
        'examName': idDispMap['cta_whole_abd']!,
        'protocolName': idDispMap['ct_second_look_abd']!,
        'useIVcontrast': true,
        'phaseDesignText': '''
- Venous (whole)
''',
        'contrastText': 'IV contrast, Oral (full positive), Rectal (positive)',
      },
    },
    'mr': {
      'mri_screening_whole_spine': {
        'header': '''
MRI Screening Whole Spine
1. Sagittal T2FS ทำ 3 stacks แยก C-T-LS spine คนละ Series
2. Check ภาพ
  - ถ้าไม่มี cord compression เลิกเคสได้เลย
  - ถ้ามี ให้วาง Plane Axial ใน level ที่สงสัย cord compression 
3. Axial ทำ 3 sequences ได้แก่ T2W, T1W, GRE T2W

If ส่ง neuro -> **ไม่ฉีด Gd ทุกกรณี**; If ส่ง MSK -> consult fellow

Remark:
* ถ้าไม่มี cord compression จะไม่ทำ axial view 
* การวาง plane axial ให้ทำเฉพาะ level ที่สงสัย cord compression โดยวาง coverage ขึ้นข้างบน 2 levels และลงล่าง 2 levels (เช่น lesion T5 ให้วางตั้งแต่ T3-T7)
* ถ้าสงสัย spinal cord infarct ให้ add sag DWI/ADC ด้วย
''',
        'useIVcontrast': false,
      },
    },
  };
}
