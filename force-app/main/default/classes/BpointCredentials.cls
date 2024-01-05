public class BpointCredentials {

    private static String pafAuthBase64 = 'YXBpIHVzZXJ8NTM1MzEwOTI5MDY4MTY5NjpJbDY2WDREcHgx';

    private static String allsAuthBase64 = 'YXBpIHVzZXJ8NTM1MzEwOTI5Nzk4NDI5NzpHcyExMm5JezFs';

    private static String tadAuthBase64 = 'dGFkd2VifDUzNTMxMDkyOTU0MTc1NDU6RHg4QS83KnUyYQ==';

    public static String getPafAuthorization(){
        String authHeader = pafAuthBase64;
        return authHeader;
    }

    public static String getAllAuthorization(){
        String authHeader = allsAuthBase64;
        return authHeader;
    }

    public static String getTadAuthorization(){
        String authHeader = tadAuthBase64;
        return authHeader;
    }

    public static String getSubAuthHeader(String sub) {
        String result;
        if (sub == 'PAF') {
            result = getPafAuthorization();
        } else if (sub == 'Allstar') {
            result = getAllAuthorization();
        } else if (sub == 'TAD' || sub == 'TC') {
            result = getTadAuthorization();
        } else {
            result = 'NOTAVALIDRESULT';
        }  //PAF '012N0000000579F' ALLSTAR '012N0000000579K'
        return result;
    }
}