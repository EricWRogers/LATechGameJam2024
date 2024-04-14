using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

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

    public bool pickedUpUpgrade = false;

    public GameObject popUpUI;
    public GameObject USB;

    public TMP_Text upgradeNameOneText;
    public TMP_Text upgradeNameTwoText;
    public TMP_Text upgradeNameThreeText;

    public TMP_Text upgradeDescriptionText;

    // Start is called before the first frame update
    void Start()
    {
        ShuffleList(upgrades);
    }

    // Update is called once per frame
    void Update()
    {
        if(pickedUpUpgrade)   
        {
            OpenPopUp();
        }
    }

    private void ShuffleList<T>(List<T> list)
    {
        int n = list.Count;
        while (n > 1)
        {
            n--;
            int k = Random.Range(0, n + 1);
            T value = list[k];
            list[k] = list[n];
            list[n] = value;
        }
    }

    public void OpenPopUp()
    {
        
        ShuffleList(upgrades);

        List<Upgrade> firstThreeUpgrades = new List<Upgrade>();
        for (int i = 0; i < Mathf.Min(3, upgrades.Count); i++)
        {
            firstThreeUpgrades.Add(upgrades[i]);
            upgradeNameOneText.text = firstThreeUpgrades[2].name;
            upgradeNameTwoText.text = firstThreeUpgrades[1].name; 
        }
        
    }
}
