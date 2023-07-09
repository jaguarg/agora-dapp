import * as fs from 'fs';
import { ethers } from "ethers";
import { IExecDataProtector, getWeb3Provider } from '@iexec/dataprotector';
const MAX_NUMBER_OF_ACCESS = 100000000;
async function createMiniPool() {
    let poolConfigArg = process.argv.pop() || "";
    let poolConfig;
    try {
        poolConfig = JSON.parse(poolConfigArg);
        console.log("poolConfig", poolConfig);
    }
    catch (jsonParseException) {
        console.error("Unable to parse args to js. Command line:", process.argv.join(' '));
        throw jsonParseException;
    }
    const wallet = ethers.Wallet.createRandom();
    const privateKey = wallet.privateKey;
    const web3Provider = getWeb3Provider(privateKey);
    const dataProtector = new IExecDataProtector(web3Provider);
    poolConfig.poolPrivateKey = privateKey;
    //1. Create the protected data with the pk and pool definition
    try {
        const protectedData = await dataProtector.protectData({
            name: "MiniPool " + (poolConfig.poolName || ""),
            data: poolConfig
        });
        console.log("protectedData", protectedData);
        //2. For each authorized app and for each authorized requester grant access 
        let authorizedUsers = poolConfig.authorizedUsers ? poolConfig.authorizedUsers.split(',') : [];
        let authorizedApps = poolConfig.autorizedApps.split(',');
        await authorizedUsers.forEach(async (user) => {
            await authorizedApps.forEach(async (app) => {
                console.log("user", user, "app", app);
                const grantedAccess = await dataProtector.grantAccess({
                    protectedData: protectedData.address,
                    authorizedApp: app,
                    authorizedUser: user,
                    numberOfAccess: MAX_NUMBER_OF_ACCESS
                });
            });
        });
    }
    catch (dataProtectorException) {
        console.error("Processing error. Command line:", process.argv.join(' '), "Exception", dataProtectorException);
        throw dataProtectorException;
    }
    return wallet.address;
}
async function writeResult(secretWalletAddress) {
    const fsPromises = fs.promises;
    const iexecOut = process.env.IEXEC_OUT;
    //Append some results in /iexec_out/
    await fsPromises.writeFile(`${iexecOut}/result.json`, secretWalletAddress);
    const computedJsonObj = {
        "deterministic-output-path": `${iexecOut}/`,
    };
}
(async () => {
    try {
        let secretWalletAddress = await createMiniPool();
        writeResult(secretWalletAddress);
    }
    catch (e) {
        // Deal with the fact the chain failed
        console.error(e);
    }
    // `text` is not available here
})();
