using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEditor;

public class ReturnToMainMenu : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        if(Input.anyKey)
        {
            MainMenu();
        }
    }

    public void MainMenu()
    {
        Time.timeScale = 1.0f;
        SceneManager.LoadSceneAsync("MainMenu");
    }
}
