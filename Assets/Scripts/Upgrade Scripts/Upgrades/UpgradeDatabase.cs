using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public struct DialogueBox
{
    public string Name;
    public Sprite Icon;
    public string Description;
}

public class UpgradeDatabase : MonoBehaviour
{
    public List<Upgrade> upgrades;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
