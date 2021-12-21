const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther('0.1'),
    });
    await waveContract.deployed();

    console.log("Contract deployed to:", waveContract.address);
    
    let contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );


    let waveTxn = await waveContract.wave("Wave # 1");
    await waveTxn.wait();

    waveTxn = await waveContract.wave("Wave # 2");
    await waveTxn.wait();
    
    contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log(
        'Contract balance:',
        hre.ethers.utils.formatEther(contractBalance)
    );    

    // waveTxn = await waveContract.connect(randomPerson).wave("Hello");
    // await waveTxn.wait();

    // waveTxn = await waveContract.connect(randomPerson).wave("Hello2");
    // await waveTxn.wait();

    // waveTxn = await waveContract.connect(randomPerson).wave("Hello3");
    // await waveTxn.wait();
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();