#Include 'Protheus.ch'

/*Funcao a ser utilizada no gatilho para o campo B1_ZZCONTA
//que deverá ter o conteúdo dos campos das outras concatendos com a seguinte ordem:
Company > B1_ITEMCC
Cost Center > B1_CC
Customer > B1_CLVL
Account > B1_CONTA
Activity > B1_EC05DB
Activity > B1_EC06DB
*/

User Function retcta()

Local cCtaDHL := ""

	cCtaDHL := RTRIM(M->B1_ITEMCC) + "." + RTRIM(M->B1_CC) + "." + RTRIM(M->B1_CLVL) + "." + RTRIM(M->B1_CONTA) + "." + RTRIM(M->B1_EC05DB) + "." + RTRIM(M->B1_EC06DB)

Return cCtaDHL

