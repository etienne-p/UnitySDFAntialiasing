using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(Helper))]
public class HelperInspector : Editor
{
    public override void OnInspectorGUI()
    {
        Helper helper = (Helper)target;
        DrawDefaultInspector();
        helper.technique = (Helper.Technique)EditorGUILayout.EnumPopup("Antialiasing technique", helper.technique);
    }
}