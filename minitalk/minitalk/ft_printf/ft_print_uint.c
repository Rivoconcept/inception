/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_print_base_uint.c                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/04/02 08:12:49 by rhanitra          #+#    #+#             */
/*   Updated: 2024/04/02 08:14:01 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "ft_printf.h"
#include "limits.h"

static char	*str_format(unsigned int n, int base)
{
	char	*str;
	int		size;

	size = 0;
	if (base == 2)
		size = (n * 3) + 2;
	if (base == 10)
		size = n + 1;
	if (base == 16)
		size = n + 1;
	str = (char *)malloc((sizeof(char) * size));
	if (!str)
		return (NULL);
	return (str);
}

char	*reverse_order(const char *str)
{
	int		i;
	int		j;
	char	*new_str;

	j = 0;
	i = ft_strlen(str) - 1;
	new_str = (char *)malloc(sizeof(char) * ft_strlen(str) + 1);
	while (i >= 0)
	{
		new_str[j] = str[i];
		i--;
		j++;
	}
	new_str[j] = '\0';
	return (new_str);
}

char	*ft_putnbr_uint(char const *base, unsigned int input, int base_type)
{
	int		i;
	int		value;
	char	*str;
	char	*ret;

	i = 0;
	str = str_format(ft_nbrlen(input), base_type);
	if (!str)
		ft_strdup("");
	if (input == 0)
	{
		free(str);
		return ("0");
	}
	while (input > 0)
	{
		value = input % base_type;
		str[i++] = base[value];
		input /= base_type;
	}
	str[i] = '\0';
	ret = reverse_order(str);
	free(str);
	return (ret);
}

int	ft_print_uint(unsigned int input, const char *base, int base_type)
{
	int		i;
	char	*str;

	str = ft_putnbr_uint(base, input, base_type);
	if (!str)
		return (write(1, "(null)", 6));
	i = ft_strlen(str);
	ft_print_str(str);
	if (input != 0)
		free(str);
	return (i);
}
