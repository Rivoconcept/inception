#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <fcntl.h>
#include <string.h>

int	n_len(int n)
{
	long	i;

	i = 0;
	if (n <= 0)
		i++;
	while (n)
	{
		n = n / 10;
		i++;
	}
	return (i);
}

char	*ft_itoa(int n)
{
	int			i;
	int long	nbr;
	int			size;
	char		*str;

	i = 0;
	nbr = (int long)n;
	size = n_len(nbr);
	str = (char *)malloc(sizeof(char) * size + 1);
	if (!str)
		return (0);
	str[size] = '\0';
	if (nbr < 0)
	{
		nbr = -nbr;
		str[0] = '-';
		i++;
	}
	while (i < size)
	{
		str[--size] = (nbr % 10) + 48;
		nbr /= 10;
	}
	return (str);
}

char binary_to_char(const char *bin)
{
    char    c;
    int     size;
    int i = 0;

    c = 0;
    i = 0;
    size = strlen(bin);
    while (i < size)
    {
        if (bin[i] == '1')
            c += 1 << (size - 1 - i);
        i++;
    }
    return (c);
}

void print_bits(unsigned char octet)
{
    int             i;
    unsigned char   bit;

    i = 8;
    bit = 0;
    while (i--)
    {
        bit = (octet >> i & 1) + 48;
        write(1, &bit, 1);
    }
}

int main(void)
{
    unsigned char c;

    c = binary_to_char("00110010");
    //print_bits(c);
     write(1, &c, 1);
    printf("\n");
    printf("%s\n", ft_itoa(21474836478));
    return (0);
}
