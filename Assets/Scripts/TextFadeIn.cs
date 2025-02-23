using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class TextFadeIn : MonoBehaviour
{
    public float fadeInTime = 2f;
    public TextMeshProUGUI title;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(FadeIn());
    }

    IEnumerator FadeIn()
    {
        Color textColor = title.color;
        float alpha = 0f; 

        while (alpha < 1f)
        {
            alpha += Time.deltaTime / fadeInTime;
            textColor.a = Mathf.Clamp01(alpha); 
            title.color = textColor; 
            yield return null; 
        }
    }
}
