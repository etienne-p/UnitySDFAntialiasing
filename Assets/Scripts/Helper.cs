using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshRenderer))]
public class Helper : MonoBehaviour 
{
    public enum Technique { None, Default, SuperSampling, Subpixel }

    [SerializeField] Material matDefault;
    [SerializeField] Material matSuperSampling;
    [SerializeField] Material matSubpixel;

    MeshRenderer meshRenderer;

    Technique m_Technique = Technique.None;

    public Technique technique 
    {
        get { return m_Technique; }
        set 
        {
            m_Technique = value;
            Material selected = null;
            switch (value)
            {
                case Technique.Default:
                    selected = matDefault;
                    break;
                case Technique.SuperSampling:
                    selected = matSuperSampling;
                    break;
                case Technique.Subpixel:
                    selected = matSubpixel;
                    break;
                default: break;
            }
            if (meshRenderer == null)
                meshRenderer = GetComponent<MeshRenderer>();
            meshRenderer.material = selected;
        }
    }
}
