using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshRenderer))]
public class Helper : MonoBehaviour 
{
    public enum Technique { None, Default, SuperSampling, Subpixel, SubpixelSuperSampled }

    [SerializeField]
    Shader sdfShader;

    static Dictionary<Technique, string> MakeKeywordsLookup()
    {
        var dict = new Dictionary<Technique, string>();
        dict[Technique.None] = "SDF_NONE";
        dict[Technique.Default] = "SDF_DEFAULT";
        dict[Technique.SuperSampling] = "SDF_SUPERSAMPLE";
        dict[Technique.Subpixel] = "SDF_SUBPIXEL";
        dict[Technique.SubpixelSuperSampled] = "SDF_SUPERSAMPLE_SUBPIXEL";
        return dict;
    }

    readonly Dictionary<Technique, string> keywords = MakeKeywordsLookup();

    // so that we can associate settings to techniques
    struct Settings
    {
        public float threshold;
        public float smoothness;
    }

    Dictionary<Technique, Settings> settingsLookup = new Dictionary<Technique, Settings>();

    Material sdfMaterial;

    Technique m_Technique = Technique.None;
    Technique m_PrevTechnique = Technique.None;

    public Technique technique 
    {
        get { return m_Technique; }
        set 
        {
            if (sdfShader == null || m_Technique == value)
                return;

            if (sdfMaterial == null)
            {
                sdfMaterial = new Material(sdfShader);
                sdfMaterial.hideFlags = HideFlags.DontSave;
                GetComponent<MeshRenderer>().material = sdfMaterial;
            }

            SaveSettings(m_Technique, sdfMaterial);

            m_PrevTechnique = m_Technique;
            m_Technique = value;

            LoadSettings(m_Technique, sdfMaterial);

            Shader.DisableKeyword(keywords[m_PrevTechnique]);
            Shader.EnableKeyword(keywords[m_Technique]);
        }
    }

    void SaveSettings(Technique technique, Material mat)
    {
        settingsLookup[technique] = new Settings()
        {
            threshold = mat.GetFloat("_Threshold"),
            smoothness = mat.GetFloat("_Smoothness")
        };
    }

    void LoadSettings(Technique technique, Material mat)
    {
        Settings settings;
        if (settingsLookup.TryGetValue(technique, out settings))
        {
            mat.SetFloat("_Threshold", settings.threshold);
            mat.SetFloat("_Smoothness", settings.smoothness);
        }
    }
}
